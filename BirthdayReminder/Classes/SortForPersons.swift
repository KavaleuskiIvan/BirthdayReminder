//
//  SortForPersons.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 16/04/2022.
//

import Foundation

class SortForPersons {
    
    static let shared = SortForPersons()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    
    func checkingWhichSortType(persons: [Person]) -> [Person] {
        let userDefValue = userDefaults.string(forKey: FiltersKeys.filteredBy)
        if userDefValue == Sorters.byName {
            let filteredPersons = persons.sort(byType: .name)
            return filteredPersons
        }
        if userDefValue == Sorters.byDayOfBirthday {
            let filteredPersons = persons.sort(byType: .dayOfBirthday)
            return filteredPersons
        }
        if userDefValue == Sorters.byAge {
            let filteredPersons = persons.sort(byType: .age)
            return filteredPersons
        }
        return persons
    }
    
    enum Sorters {
        static var byName: String = "byName"
        static var byDayOfBirthday: String = "byDayOfBirthday"
        static var byAge: String = "byAge"
    }
    
    struct FiltersKeys {
        static let filteredBy = "filteredBy"
    }
}

enum SortTypes: CaseIterable {
    case name
    case dayOfBirthday
    case age
    var sort: (Person, Person) -> Bool {
        switch self {
        case .name:
            return { $0.name ?? "" < $1.name ?? "" }
        case .dayOfBirthday:
            return { $0.dayOfBirthday ?? Date.now < $1.dayOfBirthday ?? Date.now }
        case .age:
            return { UtilsForBirthdayCalculating.calculateAge(birthday: $0.dayOfBirthday ?? Date.now) < UtilsForBirthdayCalculating.calculateAge(birthday: $1.dayOfBirthday ?? Date.now) }
        }
    }
}

extension Array where Element == Person {
    func sort(byType: SortTypes) -> [Element] {
        return self.sorted(by: byType.sort)
    }
}
