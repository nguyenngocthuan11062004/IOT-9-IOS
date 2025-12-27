//
//  ScheduleCard.swift
//  IOT-App
//

import SwiftUI

struct ScheduleCard: View {

    @State private var showSchedule = false

    var body: some View {
        Button {
            showSchedule = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.black)
                        Text("Lịch bơm")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }

                    Text("Xem & quản lý lịch bơm tự động")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showSchedule) {
            NavigationStack {
                ScheduleListScreen()

                    .preferredColorScheme(.light)

                    .navigationTitle("Lịch bơm")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.light, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color.white, for: .navigationBar)

                    .tint(Color.green)

                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Đóng") { showSchedule = false }
                                .foregroundColor(.black) // chữ đen đúng ý Anh
                        }
                    }
            }
            .presentationBackground(Color.white)
        }

    }
}
