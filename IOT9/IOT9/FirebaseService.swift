import Foundation
import FirebaseDatabase

final class FirebaseService {

    private let ref: DatabaseReference
    private var sensorHandle: DatabaseHandle?

    init() {
        self.ref = Database.database().reference()
    }

    deinit {
        removeListener()
    }

    func observeSensorData(
        onUpdate: @escaping (SensorData?) -> Void
    ) {
        removeListener()

        sensorHandle = ref.child("sensor").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                DispatchQueue.main.async {
                    onUpdate(nil)
                }
                return
            }

            let sensorData = SensorData(
                id: snapshot.key,
                humidity: self.makeReading(value, "humidity"),
                rainStatus: self.makeReading(value, "rain_status"),
                relay: self.makeReading(value, "relay"),
                temperature: self.makeReading(value, "temperature")
            )

            DispatchQueue.main.async {
                onUpdate(sensorData)
            }
        }
    }

    func updatePumpStatus(isOn: Bool) {
        let status = isOn ? "ON" : "OFF"
        ref.child("sensor/relay").setValue([
            "value": status,
            "timestamp": Date().timeIntervalSince1970
        ])
    }

    func removeListener() {
        if let handle = sensorHandle {
            ref.child("sensor").removeObserver(withHandle: handle)
            sensorHandle = nil
        }
    }

    // MARK: - Helpers

    private func makeReading(
        _ root: [String: Any],
        _ key: String
    ) -> SensorReading {

        let data = root[key] as? [String: Any]

        let timestamp = data?["timestamp"] as? Double ?? 0
        let rawValue = data?["value"]

        return SensorReading(
            timestamp: timestamp,
            value: parseValue(rawValue)
        )
    }

    private func parseValue(_ value: Any?) -> String {
        if let string = value as? String {
            return string
        }
        if let double = value as? Double {
            return String(double)
        }
        if let int = value as? Int {
            return String(int)
        }
        return ""
    }
}
