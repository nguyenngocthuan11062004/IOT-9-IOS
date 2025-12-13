//
//  InfoCard.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//
import SwiftUI

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.green.opacity(0.9))
            
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0x44/255, green: 0x76/255, blue: 0x61/255))
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .offset(y: 8)
        }
        .frame(maxWidth: .infinity,
               minHeight: 90,
               alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)
    }
}

// MARK: - PREVIEW

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview 1: Một thẻ đơn lẻ
            InfoCard(
                icon: "wind",
                title: "Độ ẩm\nngoài trời",
                value: "74%"
            )
            .previewLayout(.sizeThatFits)
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.286, green: 0.859, blue: 0.525),
                        Color(red: 0.063, green: 0.153, blue: 0.102)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // Preview 2: Nguyên cụm 3 InfoCard giống MainView
            HStack(spacing: 5) {
                InfoCard(icon: "wind", title: "Độ ẩm\nngoài trời", value: "74%")
                InfoCard(icon: "drop", title: "Nhiệt độ", value: "85%")
                InfoCard(icon: "thermometer", title: "Độ ẩm đất", value: "23°c")
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.286, green: 0.859, blue: 0.525),
                        Color(red: 0.063, green: 0.153, blue: 0.102)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .previewLayout(.sizeThatFits)
        }
    }
}
