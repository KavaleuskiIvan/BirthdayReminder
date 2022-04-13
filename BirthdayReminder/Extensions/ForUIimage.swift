//
//  ForUIimage.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 31/03/2022.
//

import UIKit

extension UIImage {
    
    func create(data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
}
