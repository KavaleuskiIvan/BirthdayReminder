//
//  PersonsCoreDataManager.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 07/04/2022.
//

import Foundation
import UIKit
import CoreData

class PersonsCoreDataManager {
    
    static let shared = PersonsCoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchPersons(completion: @escaping (Result<[Person], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        do {
            let newPersons = try context.fetch(fetchRequest)
            completion(.success(newPersons))
        } catch {
            completion(.failure(error))
            print("Could not save while fetching persons: \(error.localizedDescription)")
        }
    }
    
    func fetchPerson(withID id: UUID, completion: @escaping (Result<Person, Error>) -> Void){
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let fetchedPersons = try context.fetch(fetchRequest)
            guard let fetchedPerson = fetchedPersons.first else { return }
            completion(.success(fetchedPerson))
        } catch {
            completion(.failure(error))
            print("Could not save while fetching person: \(error.localizedDescription)")
        }
    }
    
    func savePerson(personName: String, persondayOfBirthday: Date, personImage: UIImage) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        
        let person = Person(entity: entity, insertInto: context)
        
        person.id = UUID.init()
        person.name = personName
        person.dayOfBirthday = persondayOfBirthday
        person.image = personImage.jpegData(compressionQuality: 1)
        
        do {
            try context.save()
        } catch {
            print("Could not save person: \(error.localizedDescription)")
        }
    }
    
    func updatePerson(person: Person?, name: String, dayOfBirthday: Date, image: UIImage) {
        guard let _person = person else { return }
        _person.setValue(name, forKey: "name")
        _person.setValue(dayOfBirthday, forKey: "dayOfBirthday")
        _person.setValue(image.jpegData(compressionQuality: 1), forKey: "image")
        
        do {
            try context.save()
        } catch {
            print("Could not save whiel updating person: \(error.localizedDescription)")
        }
    }
    
    func deletePersons(personsArray: [Person], atIndexPath indexPath: IndexPath) {
        context.delete(personsArray[indexPath.row])
        
        do {
            try context.save()
        } catch {
            print("Could not save while deleting: \(error.localizedDescription)")
        }
    }
    
    func deletePerson(person: Person?) {
        guard let _person = person else { return }
        context.delete(_person)
        
        do {
            try context.save()
        } catch {
            print("Could not save while deleting: \(error.localizedDescription)")
        }
    }
}
