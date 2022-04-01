//
//  Person+CoreDataProperties.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 01/04/2022.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dayOfBirthday: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?

}

extension Person : Identifiable {

}
