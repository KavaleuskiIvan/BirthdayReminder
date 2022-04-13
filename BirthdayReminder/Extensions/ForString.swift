//
//  ForString.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 03/04/2022.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "dd-MM-yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}
