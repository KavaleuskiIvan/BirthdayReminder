//
//  ForUIViewController.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 29/03/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func addCornerRadius(name: UIView) {
        name.layoutIfNeeded()
        name.layer.cornerRadius = name.frame.height/4.0
        name.layer.masksToBounds = true
    }
}
