//
//  FirebaseService.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 11/12/25.
//

// FirebaseService.swift
import Firebase

class FirebaseService {
    private var ref: DatabaseReference!

    init() {
        ref = Database.database().reference()
    }

    // Hàm lấy dữ liệu từ Firebase Realtime Database
    func fetchSensorData(completion: @escaping (SensorData?) -> Void) {
        ref.child("sensor").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            // Lấy dữ liệu từ các node con của "sensor"
            let humidityData = value["humidity"] as? [String: Any]
            let rainStatusData = value["rain_status"] as? [String: Any]
            let relayData = value["relay"] as? [String: Any]
            let temperatureData = value["temperature"] as? [String: Any]
            
            // Tạo các đối tượng SensorReading từ dữ liệu Firebase
            let humidity = SensorReading(
                timestamp: humidityData?["timestamp"] as? Double ?? 0,
                value: humidityData?["value"] as? String ?? ""
            )
            
            let rainStatus = SensorReading(
                timestamp: rainStatusData?["timestamp"] as? Double ?? 0,
                value: rainStatusData?["value"] as? String ?? ""
            )
            
            let relay = SensorReading(
                timestamp: relayData?["timestamp"] as? Double ?? 0,
                value: relayData?["value"] as? String ?? ""
            )
            
            let temperature = SensorReading(
                timestamp: temperatureData?["timestamp"] as? Double ?? 0,
                value: temperatureData?["value"] as? String ?? ""
            )
            
            // Tạo SensorData từ các đối tượng SensorReading
            let sensorData = SensorData(
                id: snapshot.key,
                humidity: humidity,
                rainStatus: rainStatus,
                relay: relay,
                temperature: temperature
            )
            
            completion(sensorData)
        }
    }

    // Hàm cập nhật trạng thái bơm (relay) trong Firebase
    func updatePumpStatus(isOn: Bool) {
        let pumpStatus = isOn ? "ON" : "OFF"
        ref.child("sensor/relay").setValue([
            "value": pumpStatus,
            "timestamp": Date().timeIntervalSince1970 // Thêm timestamp nếu cần
        ]) { error, _ in
            if let error = error {
                print("Error updating pump status: \(error.localizedDescription)")
            } else {
                print("Pump status updated to \(pumpStatus)")
            }
        }
    }
}
