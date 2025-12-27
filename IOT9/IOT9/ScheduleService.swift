import FirebaseDatabase

final class ScheduleService {
    private let ref = Database.database().reference()

    // MARK: - V1 (giữ lại cho backward compatibility)
    func createDailySchedule(
        id: String,
        hour: Int,
        minute: Int,
        durationSeconds: Int
    ) {
        let data: [String: Any] = [
            "enabled": true,
            "hour": hour,
            "minute": minute,
            "duration_sec": durationSeconds,
            "repeat_type": "daily"
        ]

        ref.child("schedules/\(id)").setValue(data)
    }

    // MARK: - V2 (NEW – có ngày + lặp)
    func createScheduleV2(
        id: String,
        hour: Int,
        minute: Int,
        date: Date?,
        repeatType: RepeatType,
        repeatDays: [Int],
        durationSeconds: Int
    ) {
        var data: [String: Any] = [
            "enabled": true,
            "hour": hour,
            "minute": minute,
            "duration_sec": durationSeconds,
            "repeat_type": repeatType.rawValue
        ]

        if let date {
            data["date"] = Int(date.timeIntervalSince1970)
        }

        if repeatType == .weekly {
            data["repeat_days"] = repeatDays
        }

        ref.child("schedules/\(id)").setValue(data) { error, _ in
            if let error {
                print("❌ createScheduleV2 failed:", error.localizedDescription)
            } else {
                print("✅ Schedule V2 saved:", id)
            }
        }
    }

    // MARK: - READ
    func observeSchedules(onUpdate: @escaping ([Schedule]) -> Void) {
        ref.child("schedules").observe(.value) { snapshot in
            guard let raw = snapshot.value as? [String: Any] else {
                DispatchQueue.main.async { onUpdate([]) }
                return
            }

            let schedules: [Schedule] = raw.compactMap { key, value in
                guard let dict = value as? [String: Any] else { return nil }

                let repeatType = RepeatType(
                    rawValue: dict["repeat_type"] as? String ?? "daily"
                ) ?? .daily

                return Schedule(
                    id: key,
                    hour: dict["hour"] as? Int ?? 0,
                    minute: dict["minute"] as? Int ?? 0,
                    date: {
                        if let ts = dict["date"] as? Int {
                            return Date(timeIntervalSince1970: TimeInterval(ts))
                        }
                        return nil
                    }(),
                    repeatType: repeatType,
                    repeatDays: dict["repeat_days"] as? [Int] ?? [],
                    durationSeconds: dict["duration_sec"] as? Int ?? 300,
                    enabled: dict["enabled"] as? Bool ?? true
                )
            }
            .sorted { ($0.hour, $0.minute) < ($1.hour, $1.minute) }

            DispatchQueue.main.async {
                onUpdate(schedules)
            }
        }
    }

    // MARK: - UPDATE / DELETE
    func setScheduleEnabled(id: String, enabled: Bool) {
        ref.child("schedules/\(id)/enabled").setValue(enabled)
    }

    func deleteSchedule(id: String) {
        ref.child("schedules/\(id)").removeValue()
    }
}
