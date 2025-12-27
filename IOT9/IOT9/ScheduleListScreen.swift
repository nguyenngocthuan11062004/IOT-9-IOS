//
//  ScheduleListScreen.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 27/12/25.
//
import SwiftUI

struct ScheduleListScreen: View {

    @State private var schedules: [Schedule] = []
    @State private var showAdd = false

    private let service = ScheduleService()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {

                if schedules.isEmpty {
                    Text("Chưa có lịch bơm")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }

                ForEach(schedules) { schedule in
                    scheduleRow(schedule)
                }
            }
            .padding()
        }
        .navigationTitle("Lịch bơm")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            AddEditScheduleScreen()
        }
        .onAppear {
            service.observeSchedules { list in
                self.schedules = list
            }
        }
    }

    // MARK: - Simple Row
    private func scheduleRow(_ schedule: Schedule) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%02d:%02d", schedule.hour, schedule.minute))
                    .font(.system(size: 16, weight: .semibold))

                Text(scheduleDescription(schedule))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { schedule.enabled },
                set: { newValue in
                    service.setScheduleEnabled(
                        id: schedule.id,
                        enabled: newValue
                    )
                }
            ))
            .labelsHidden()

            Button {
                service.deleteSchedule(id: schedule.id)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }

    private func scheduleDescription(_ schedule: Schedule) -> String {
        switch schedule.repeatType {
        case .none:
            return "Một lần • \(schedule.durationSeconds / 60) phút"
        case .daily:
            return "Hằng ngày • \(schedule.durationSeconds / 60) phút"
        case .weekly:
            let days = schedule.repeatDays
                .sorted()
                .map { weekdayName($0) }
                .joined(separator: ", ")
            return "Hằng tuần (\(days)) • \(schedule.durationSeconds / 60) phút"
        }
    }

    private func weekdayName(_ day: Int) -> String {
        ["CN","T2","T3","T4","T5","T6","T7"][day - 1]
    }
}
