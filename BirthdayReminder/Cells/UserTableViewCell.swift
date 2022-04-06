//
//  UserTableViewCell.swift
//  Birthday Reminder
//
//  Created by Kavaleuski Ivan on 13/01/2022.
//

import UIKit

extension UserTableViewCell: ReusableView { }

class UserTableViewCell: UITableViewCell {
    
    let personsPhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let personsName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let personsDayOfBirthday: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let personsAge: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(person: Person) {
        if let image = UIImage().create(data: person.image) {
            personsPhoto.image = image
        }
        personsName.text = person.name
        if let date = person.dayOfBirthday {
            personsAge.text = String(calculateAge(birthday: date))
            personsDayOfBirthday.text = "\(date.toString(dateFormat: "dd-MM-yyyy")),  \(checkIfBirthday(date: date))"
        }
    }
    
    func checkIfBirthday(date: Date) -> String {
        let days = calculateDaysLeft(birthday: date)
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: .now)
        if (ageComponents.isLeapMonth ?? false && days == 366) {
            return "Happy Birthday"
        } else if (!ageComponents.isLeapMonth! && days == 365) {
            return "Happy Birthday"
        } else {
            return "\(days) days left"
        }
    }
    
    func addSubviews() {
        contentView.addSubview(personsName)
        contentView.addSubview(personsDayOfBirthday)
        contentView.addSubview(personsAge)
        contentView.addSubview(personsPhoto)
    }
    
    func calculateAge(birthday: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    
    func calculateDaysLeft(birthday: Date) -> Int {
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

    // MARK: Constraints
private extension UserTableViewCell {
    func addCornerRadius(name: UIView) {
        name.layoutIfNeeded()
        name.layer.cornerRadius = name.frame.height/1.5
        name.layer.masksToBounds = true
    }
    func setupConstraints() {
        
        personsPhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        personsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        personsPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        personsPhoto.widthAnchor.constraint(equalTo: personsPhoto.heightAnchor).isActive = true
        personsPhoto.layoutIfNeeded()
        personsPhoto.layer.cornerRadius = personsPhoto.frame.height/2
        personsPhoto.layer.masksToBounds = true
        
        personsName.leadingAnchor.constraint(equalTo: personsPhoto.trailingAnchor, constant: 3).isActive = true
        personsName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        personsName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 4/10).isActive = true
        addCornerRadius(name: personsName)
        
        personsDayOfBirthday.leadingAnchor.constraint(equalTo: personsPhoto.trailingAnchor, constant: 3).isActive = true
        personsDayOfBirthday.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        personsDayOfBirthday.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        personsDayOfBirthday.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 5/10).isActive = true
        addCornerRadius(name: personsDayOfBirthday)
        
        personsAge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        personsAge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        personsAge.leadingAnchor.constraint(equalTo: personsName.trailingAnchor, constant: 3).isActive = true
        personsAge.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 4/10).isActive = true
        personsAge.widthAnchor.constraint(equalTo: personsAge.heightAnchor).isActive = true
        addCornerRadius(name: personsAge)
    }
}
