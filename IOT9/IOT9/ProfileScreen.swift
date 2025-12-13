//
//  ProfileScreen.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//

import SwiftUI

struct ProfileScreen: View {
    @State private var language: String = "English"
    @State private var temperatureUnit: String = "Celsius"

    var body: some View {
            VStack {
                Text("Cài đặt")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 20)
                VStack {
                    // Language Section
                    VStack {
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .foregroundColor(Color.green)
                            Text("Language")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(hex: "#06492C")) // Màu cho Text "Language"
                            Spacer()
                            Text(language)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        Divider()
                    }
                    
                    // Temperature Unit Section
                    VStack {
                        HStack {
                            Image(systemName: "thermometer")
                                .foregroundColor(Color.green)
                            Text("Temperature Unit")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(hex: "#06492C")) // Màu cho Text "Temperature Unit"
                            Spacer()
                            Text(temperatureUnit)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                .background(Color.white) // Nền trắng
                .cornerRadius(12) // Bo góc 12
                .shadow(radius: 10) // Thêm bóng mờ để tạo chiều sâu
                .padding(.horizontal, 20) // Padding cho cả 2 bên
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Để phần này ở giữa màn hình

                Spacer()
            }
        }
    }

// Mở rộng để tạo một màu hex dễ sử dụng
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = scanner.string.startIndex
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
