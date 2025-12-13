//
//  HomeScreen.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//

import SwiftUI

struct HomeScreen: View {
    @State private var pumpOn: Bool = false
    @State private var sensorData: SensorData?

    private var firebaseService = FirebaseService()

    var body: some View {
        VStack(spacing: 30) {
            Text("Trang Chủ")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 20)

            // TOP GRID
            VStack(spacing: 13) {
                // HÀNG 1 – 3 CARD BẰNG NHAU
                HStack(spacing: 5) {
                    // Độ ẩm ngoài trời (humidity)
                    if let sensorData = sensorData {
                        InfoCard(icon: "wind", title: "Độ ẩm\nngoài trời", value: "\(sensorData.humidity.value)%")
                    } else {
                        InfoCard(icon: "wind", title: "Độ ẩm\nngoài trời", value: "Loading...")
                    }
                    
                    // Nhiệt độ (temperature)
                    if let sensorData = sensorData {
                        InfoCard(icon: "drop", title: "Nhiệt độ", value: "\(sensorData.temperature.value)°C")
                    } else {
                        InfoCard(icon: "drop", title: "Nhiệt độ", value: "Loading...")
                    }
                    
                    // Độ ẩm đất (soil humidity)
                    if let sensorData = sensorData {
                        InfoCard(icon: "thermometer", title: "Độ ẩm đất", value: "\(sensorData.humidity.value)%")
                    } else {
                        InfoCard(icon: "thermometer", title: "Độ ẩm đất", value: "Loading...")
                    }
                }

                // HÀNG 2 – CARD TRÁI NHỎ + CARD PHẢI TO
                HStack(spacing: 5) {
                    // Kết nối (rain_status)
                    if let sensorData = sensorData {
                        InfoCard(icon: "wifi", title: "Kết nối", value: sensorData.rainStatus.value)
                            .frame(width: 112)
                    } else {
                        InfoCard(icon: "wifi", title: "Kết nối", value: "Loading...")
                            .frame(width: 112)
                    }

                    // Pump Status
                    PumpStatusCard(pumpOn: $pumpOn)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            // Khi người dùng nhấn, cập nhật trạng thái bơm trong Firebase và giao diện
                            pumpOn.toggle()
                            firebaseService.updatePumpStatus(isOn: pumpOn)
                        }
                }

                // HÀNG 3 – FULL WIDTH
                ScheduleCard()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)

            // ACTION BUTTON
            Button {
                pumpOn.toggle()
                firebaseService.updatePumpStatus(isOn: pumpOn)
            } label: {
                Text("Bơm ngay")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .onAppear {
            // Fetch sensor data when the view appears
            firebaseService.fetchSensorData { fetchedData in
                self.sensorData = fetchedData
            }
        }
    }
}


