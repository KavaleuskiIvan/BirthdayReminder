//
//  CellsProtocols.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 05/04/2022.
//

import Foundation

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
