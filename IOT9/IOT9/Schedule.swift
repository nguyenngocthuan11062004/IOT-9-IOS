//
//  Schedule.swift
//  IOT9
//
//  Created by Thuận Nguyễn on 27/12/25.
//
import Foundation

struct Schedule: Identifiable {
    let id: String

    let hour: Int
    let minute: Int
    let date: Date?          // nếu không lặp

    let repeatType: RepeatType
    let repeatDays: [Int]    // 1 = CN ... 7 = T7

    let durationSeconds: Int
    let enabled: Bool
}

enum RepeatType: String {
    case none
    case daily
    case weekly
}
