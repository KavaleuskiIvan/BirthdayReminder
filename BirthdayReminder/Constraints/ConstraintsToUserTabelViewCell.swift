//
//  ConstraintsToUserTabelViewCell.swift
//  Birthday Reminder
//
//  Created by Kavaleuski Ivan on 19/01/2022.
//

import Foundation
import UIKit

extension UserTableViewCell {
    
    func addCornerRadius(name: UIView) {
        name.layoutIfNeeded()
        name.layer.cornerRadius = name.frame.height/3
        name.layer.masksToBounds = true
    }
    func setupConstraints() {
        
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
