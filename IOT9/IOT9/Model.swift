//
//  Model.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 11/12/25.
//

// Model.swift
import Foundation

// Model cho dữ liệu sensor
struct SensorData: Identifiable {
    var id: String
    var humidity: SensorReading
    var rainStatus: SensorReading
    var relay: SensorReading
    var temperature: SensorReading
}

// Model cho mỗi giá trị của sensor (humidity, rain_status, relay, temperature)
struct SensorReading {
    var timestamp: Double
    var value: String
}
