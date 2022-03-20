//
//  AddingBirthdayViewController.swift
//  Birthday Reminder
//
//  Created by Kavaleuski Ivan on 11/01/2022.
//

import UIKit
import CoreData

class AddingBirthdayViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.setValue(UIColor.lightGray, forKey: "backgroundColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // MARK: Adding labels, TF and button
    // Adding view and label with name
    let nameLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Add TF with entering name
    let nameTF: UITextField! = {
        let textField = UITextField()
        textField.placeholder = "Enter the name"
        textField.backgroundColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Add view and the birthday date label
    let birthdayDateLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let birthdayDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Adding add information button
    let addInformationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupConstraints()

        setupDatePicker()
    }
    
    // Create DatePicker
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }

    // Setup add information button
    @objc func addButtonAction() {
        if nameTF.text != "" {
            savePerson { finished in
                if finished {
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func savePerson(completion: (_ finished: Bool) -> ()) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        
        let person = Person(entity: entity, insertInto: context)
        person.name = nameTF.text
        person.dayOfBirthday = datePicker.date
        
        do {
            try context.save()
            completion(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Func to adding subviews
    func addSubviews() {
        view.addSubview(nameLabelView)
        view.addSubview(nameTF)
        view.addSubview(birthdayDateLabelView)
        view.addSubview(addInformationButton)
        view.addSubview(datePicker)
    }
}
