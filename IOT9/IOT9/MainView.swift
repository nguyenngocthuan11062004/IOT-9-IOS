//
//  MainView.swift
//  IOT-App
//
//  Created by Thuận Nguyễn on 10/12/25.
//

import SwiftUI


struct MainView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.286, green: 0.859, blue: 0.525),
                    Color(red: 0.063, green: 0.153, blue: 0.102)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {

                // SWITCH TABS HERE
                Group {
                    if selectedTab == 0 {
                        HomeScreen()
                    } else {
                        ProfileScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // BOTTOM NAV
                HStack(spacing: 12) {
                    BottomNavItem(icon: "icon2", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }

                    BottomNavItem(icon: "icon1", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 4/255, green: 32/255, blue: 16/255))
                )
                .frame(width: 200, height: 110)
                .padding(.bottom, 20)

            }
        }
    }
}
