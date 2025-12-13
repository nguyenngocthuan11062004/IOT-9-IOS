//
//  ScheduleCard.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//

import SwiftUI
struct ScheduleCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "clock")
                    Text("Lịch bơm")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(Color.green.opacity(0.9))

                Text("Thời gian: 20/12/2025")
                Text("Lúc: 14:52")
            }
            .font(.system(size: 14))
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.85))
                    .frame(width: 45, height: 45)
                
                Image(systemName: "pencil")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)
    }
}

