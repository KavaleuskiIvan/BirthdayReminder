//
//  ForDate.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 18/03/2022.
//

import Foundation

extension Date {
    
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
