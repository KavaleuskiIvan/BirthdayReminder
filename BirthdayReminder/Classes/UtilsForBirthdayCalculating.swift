//
//  UtilsForBirthdayCalculating.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 16/04/2022.
//

import Foundation

enum UtilsForBirthdayCalculating {
    
    static func calculateAge(birthday: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    
    static func calculateDaysLeft(birthday: Date) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayAndMonth = calendar.dateComponents([.day, .month], from: birthday)
        let nextBirthDay = calendar.nextDate(after: today,
                                             matching: dayAndMonth,
                                             matchingPolicy: .nextTimePreservingSmallerComponents)!
        
        let diff = calendar.dateComponents([.day], from: today, to: nextBirthDay)
        return diff.day ?? 0
    }
}
