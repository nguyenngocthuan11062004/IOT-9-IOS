//
//  AddEditScheduleScreen.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 27/12/25.
//

import SwiftUI

struct AddEditScheduleScreen: View {

    @Environment(\.dismiss) private var dismiss
    private let service = ScheduleService()

    // MARK: - State
    @State private var selectedDate = Date()
    @State private var durationMinutes = 5

    @State private var repeatType: RepeatType = .none
    @State private var repeatDays: Set<Int> = []

    // MARK: - UI
    var body: some View {
        NavigationStack {
            Form {

                // ===== THỜI GIAN =====
                Section(header: Text("Thời gian bơm")) {
                    DatePicker(
                        "Ngày & giờ",
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                // ===== LẶP =====
                Section(header: Text("Lặp lại")) {
                    Picker("Kiểu lặp", selection: $repeatType) {
                        Text("Không lặp").tag(RepeatType.none)
                        Text("Hằng ngày").tag(RepeatType.daily)
                        Text("Hằng tuần").tag(RepeatType.weekly)
                    }
                    .pickerStyle(.segmented)

                    if repeatType == .weekly {
                        weekdayPicker
                    }
                }

                // ===== THỜI LƯỢNG =====
                Section(header: Text("Thời lượng")) {
                    Stepper(
                        "\(durationMinutes) phút",
                        value: $durationMinutes,
                        in: 1...120
                    )
                }
            }
            .navigationTitle("Thêm lịch bơm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Huỷ") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        saveSchedule()
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Weekday picker
    private var weekdayPicker: some View {
        VStack(alignment: .leading) {
            ForEach(1...7, id: \.self) { day in
                Toggle(
                    weekdayName(day),
                    isOn: Binding(
                        get: { repeatDays.contains(day) },
                        set: { isOn in
                            if isOn {
                                repeatDays.insert(day)
                            } else {
                                repeatDays.remove(day)
                            }
                        }
                    )
                )
            }
        }
    }

    // MARK: - Save
    private func saveSchedule() {
        let comps = Calendar.current.dateComponents(
            [.hour, .minute],
            from: selectedDate
        )

        let id = UUID().uuidString

        service.createScheduleV2(
            id: id,
            hour: comps.hour ?? 0,
            minute: comps.minute ?? 0,
            date: repeatType == .none ? selectedDate : nil,
            repeatType: repeatType,
            repeatDays: Array(repeatDays),
            durationSeconds: durationMinutes * 60
        )
    }

    // MARK: - Utils
    private func weekdayName(_ day: Int) -> String {
        ["CN", "T2", "T3", "T4", "T5", "T6", "T7"][day - 1]
    }
}
