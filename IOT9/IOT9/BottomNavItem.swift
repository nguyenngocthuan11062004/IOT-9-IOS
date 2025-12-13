//
//  BottomNavItem.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//
import SwiftUI

struct BottomNavItem: View {
    let icon: String          // Tên SF Symbol hoặc tên image trong Assets
    let isSelected: Bool
    let action: () -> Void
    
    // Màu nền theo state
    private var backgroundColor: Color {
        if isSelected {
            return Color(red: 106/255, green: 223/255, blue: 155/255) // #6ADF9B
        } else {
            return Color(red: 52/255, green: 99/255, blue: 72/255)    // #346348
        }
    }
    
    // Màu icon theo state
    private var iconColor: Color {
        isSelected ? .black : Color.white.opacity(0.7)
    }
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 18)
                .fill(backgroundColor)
                .frame(width: 64, height: 64)
                .overlay(
                    Image(icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(iconColor)
                )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

struct BottomNavItem_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Nền container giống ảnh
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 18/255, green: 40/255, blue: 30/255))
                .frame(height: 90)
                .padding()
            
            HStack(spacing: 24) {
                BottomNavItem(
                    icon: "icon2", // thay bằng icon của Anh
                    isSelected: true,
                    action: {}
                )
                
                BottomNavItem(
                    icon: "icon1", // thay bằng icon của Anh
                    isSelected: true,
                    action: {}
                )
            }
            .padding(.horizontal)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
