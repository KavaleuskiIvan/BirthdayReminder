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
        picker.backgroundColor = .lightGray
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // MARK: Adding labels, TF and button
    // Adding view and label with name
    let personsPhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "default-user-image")
        return image
    }()
    let personsPhotoChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(personsPhotoChangeButtonPressed), for: .touchUpInside)
        return button
    }()
    
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
    let nameTF: UITextField = {
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
    
    @objc func personsPhotoChangeButtonPressed() {
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { _ in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Error Camera")
        }
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
    
    // MARK: Database function
    func savePerson(completion: (_ finished: Bool) -> ()) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        
        let person = Person(entity: entity, insertInto: context)
        
        person.id = UUID.init()
        person.name = nameTF.text
        person.dayOfBirthday = datePicker.date
        person.image = personsPhoto.image?.jpegData(compressionQuality: 1)
        
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
}
    // MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddingBirthdayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            personsPhoto.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

    // MARK: Constraints
extension AddingBirthdayViewController  {
    func addSubviews() {
        view.addSubview(personsPhoto)
        view.addSubview(personsPhotoChangeButton)
        view.addSubview(nameLabelView)
        view.addSubview(nameTF)
        view.addSubview(birthdayDateLabelView)
        view.addSubview(addInformationButton)
        view.addSubview(datePicker)
    }
    // Creating contraints of label in view
    func setupLabelsConstriantsInView(name: UILabel, mainView: UIView) {
        mainView.addSubview(name)
        name.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        name.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        name.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        name.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
    
    func setupConstraints() {
        // Adding contraints to imageView
        personsPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        personsPhoto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        personsPhoto.heightAnchor.constraint(equalTo: personsPhoto.widthAnchor).isActive = true
        personsPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCornerRadius(name: personsPhoto)
        // Adding contraints to changePhotoButton
        personsPhotoChangeButton.centerXAnchor.constraint(equalTo: personsPhoto.centerXAnchor).isActive = true
        personsPhotoChangeButton.centerYAnchor.constraint(equalTo: personsPhoto.centerYAnchor).isActive = true
        personsPhotoChangeButton.heightAnchor.constraint(equalTo: personsPhoto.heightAnchor).isActive = true
        personsPhotoChangeButton.widthAnchor.constraint(equalTo: personsPhoto.widthAnchor).isActive = true
        
        // Adding constraints to view with name
        nameLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        nameLabelView.topAnchor.constraint(equalTo: personsPhoto.bottomAnchor, constant: 20).isActive = true
        nameLabelView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        nameLabelView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        addCornerRadius(name: nameLabelView)
        // Adding constraints to name label in view
        setupLabelsConstriantsInView(name: nameLabel, mainView: nameLabelView)
        
        // Adding constraints to TF with entering name
        nameTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        nameTF.topAnchor.constraint(equalTo: nameLabelView.bottomAnchor,constant: 20).isActive = true
        nameTF.widthAnchor.constraint(equalTo: nameLabelView.widthAnchor).isActive = true
        nameTF.heightAnchor.constraint(equalTo: nameLabelView.heightAnchor).isActive = true
        addCornerRadius(name: nameTF)
        nameTF.indent(size: 20)
        
        // Adding constraints to label with birthday date
        birthdayDateLabelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        birthdayDateLabelView.topAnchor.constraint(equalTo: nameTF.bottomAnchor,constant: 20).isActive = true
        birthdayDateLabelView.widthAnchor.constraint(equalTo: nameLabelView.widthAnchor).isActive = true
        birthdayDateLabelView.heightAnchor.constraint(equalTo: nameLabelView.heightAnchor).isActive = true
        addCornerRadius(name: birthdayDateLabelView)
        // Adding constraints to name label in view
        setupLabelsConstriantsInView(name: birthdayDateLabel, mainView: birthdayDateLabelView)
 
        datePicker.center = view.center
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: birthdayDateLabelView.bottomAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: addInformationButton.topAnchor).isActive = true
        
        // Adding contraints to add information button
        addInformationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addInformationButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        addInformationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        addInformationButton.heightAnchor.constraint(equalTo: nameLabelView.heightAnchor).isActive = true
        addInformationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        addCornerRadius(name: addInformationButton)
    }
}
