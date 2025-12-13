//
//  PumpStatusCard.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//
import SwiftUI

// Thay đổi mức độ truy cập từ private thành internal hoặc public
struct PumpStatusCard: View {
    @Binding var pumpOn: Bool
    var firebaseService = FirebaseService()  // Khởi tạo FirebaseService

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: "scissors")
                    .font(.system(size: 20))
                    .foregroundColor(.green.opacity(0.9))
                
                Text("Trạng thái máy bơm")
                    .font(.system(size: 14))
                    .foregroundColor(Color.green.opacity(0.8))
                
                Text("Bật / Tắt")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            // Toggle để thay đổi trạng thái bơm
            Toggle("", isOn: $pumpOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .onChange(of: pumpOn) { newValue in
                    // Cập nhật trạng thái bơm vào Firebase khi trạng thái thay đổi
                    firebaseService.updatePumpStatus(isOn: newValue)
                }
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)
    }
}
