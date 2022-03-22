//
//  UserTableViewCell.swift
//  Birthday Reminder
//
//  Created by Kavaleuski Ivan on 13/01/2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "CustomCellIdentifier"
    
    let name: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayOfBirthday: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ageOfPerson: UILabel = {
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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(person: Person) {
        name.text = person.name
        ageOfPerson.text = String(calculateAge(birthday: person.dayOfBirthday!))
        
        let days = calculateDaysLeft(birthday: person.dayOfBirthday!)
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: .now)
        var status = ""
        if (ageComponents.isLeapMonth ?? false && days == 366) {
            status = "Happy Birthday"
        } else if (!ageComponents.isLeapMonth! && days == 365) {
            status = "Happy Birthday"
        } else {
            status = "\(days) days left"
        }
        
        dayOfBirthday.text = "\(person.dayOfBirthday?.toString(dateFormat: "dd-MM-yyyy") ?? ""),  \(status)"
    }
    
    func addSubviews() {
        contentView.addSubview(name)
        contentView.addSubview(dayOfBirthday)
        contentView.addSubview(ageOfPerson)
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
extension UserTableViewCell {
    func addCornerRadius(name: UIView) {
        name.layoutIfNeeded()
        name.layer.cornerRadius = name.frame.height/1.5
        name.layer.masksToBounds = true
    }
    func setupConstraints() {
        
        name.setNeedsDisplay()
        name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        name.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 7/10).isActive = true
        name.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 4/10).isActive = true
        addCornerRadius(name: name)
        
        dayOfBirthday.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        dayOfBirthday.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        dayOfBirthday.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        dayOfBirthday.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 5/10).isActive = true
        addCornerRadius(name: dayOfBirthday)
        
        ageOfPerson.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        ageOfPerson.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        ageOfPerson.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 3).isActive = true
        ageOfPerson.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 4/10).isActive = true
        addCornerRadius(name: ageOfPerson)
    }
}
