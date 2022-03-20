//
//  ForUITextField.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 18/03/2022.
//

import Foundation
import UIKit

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
