//
//  FilterForPersons.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 16/04/2022.
//

import Foundation

class FilterForPersons {
    
    static let shared = FilterForPersons()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    
    func filterPersonsByName(persons: [Person]) -> [Person] {
        let filteredPersons = persons.sorted { $0.name ?? "" < $1.name ?? "" }
        return filteredPersons
    }
    
    func filterPersonsByDayOfBirthday(persons: [Person]) -> [Person] {
        let filteredPersons = persons.sorted { $0.dayOfBirthday ?? Date.now < $1.dayOfBirthday ?? Date.now }
        return filteredPersons
    }
    
    func filterPersonsByAge(persons: [Person]) -> [Person] {
        let filteredPersons = persons.sorted {
            UtilsForBirthdayCalculating.shared.calculateAge(birthday: $0.dayOfBirthday ?? Date.now) <
                UtilsForBirthdayCalculating.shared.calculateAge(birthday: $1.dayOfBirthday ?? Date.now) }
        return filteredPersons
    }
    
    func checkingWhichFilter(persons: [Person]) -> [Person] {
        let userDefValue = userDefaults.string(forKey: FiltersKeys.filteredBy)
        if userDefValue == Filters.byName {
            let filteredPersons = filterPersonsByName(persons: persons)
            return filteredPersons
        }
        if userDefValue == Filters.byDayOfBirthday {
            let filteredPersons = filterPersonsByDayOfBirthday(persons: persons)
            return filteredPersons
        }
        if userDefValue == Filters.byAge {
            let filteredPersons = filterPersonsByAge(persons: persons)
            return filteredPersons
        }
        return persons
    }
    
    struct Filters {
        static var byName: String = "byName"
        static var byDayOfBirthday: String = "byDayOfBirthday"
        static var byAge: String = "byAge"
    }
    struct FiltersKeys {
        static let filteredBy = "filteredBy"
    }
}
