//
//  DetailViewController.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 28/03/2022.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var person: Person?
    var personID: UUID = UUID()
    
    let personsPhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        return image
    }()
    
    let personsNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let personsNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.text = "Name: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let personsNameTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let personsDayOfBirthdayView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let personsDayOfBirthdayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.text = "Date: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let personsDayOfBirthdayTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .lightGray
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
        
        fetchPerson()
        setupInformation()
        
        launchBackButton()
        launchSettingsButton()
    }
    
    func setupInformation() {
        if let image = UIImage().create(data: person?.image) {
            personsPhoto.image = image
        }
        personsNameTextLabel.text = person?.name ?? ""
        personsDayOfBirthdayTextLabel.text = person?.dayOfBirthday?.toString(dateFormat: "dd-MM-yyyy") ?? ""
    }
    
    func launchBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonPressed() {
        updatePerson()
        navigationController?.popViewController(animated: true)
    }
    
    func launchSettingsButton() {
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingsButtonPressed))
        self.navigationItem.rightBarButtonItem = settingsButton
    }
    @objc func settingsButtonPressed() {
        let settingsAlert = UIAlertController(title: "Settings", message: "Pick to change", preferredStyle: .actionSheet)
        // Alert for changing photo
        settingsAlert.addAction(UIAlertAction(title: "Change Photo", style: .default, handler: { [weak self] _ in
            let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self?.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                self?.openGallery()
            }
            let defaultAction = UIAlertAction(title: "Set default image", style: .default) { _ in
                self?.personsPhoto.image = UIImage(named: "default-user-image")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true, completion: nil)
        }))
        
        // Alert for changing name
        settingsAlert.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { [weak self] _ in
            let changeNameAlert = UIAlertController(title: "Enter name", message: "", preferredStyle: .alert)
            changeNameAlert.addTextField(configurationHandler: { textField in
                textField.text = self?.personsNameTextLabel.text
            })
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
                let text = changeNameAlert.textFields?.first?.text
                self?.personsNameTextLabel.text = text
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
            changeNameAlert.addAction(saveAction)
            changeNameAlert.addAction(cancelAction)
            self?.present(changeNameAlert, animated: true, completion: nil)
        }))
        
        // Alert for changing date
        settingsAlert.addAction(UIAlertAction(title: "Change Date", style: .default, handler: { [weak self] _ in
            let changeDateAlert = UIAlertController(title: "Enter date", message: "", preferredStyle: .alert)
            
            //Constraints to datePicker
            guard let self = self else { return }
            changeDateAlert.view.addSubview(self.datePicker)
            changeDateAlert.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
            self.datePicker.heightAnchor.constraint(equalTo: changeDateAlert.view.heightAnchor, constant: -80).isActive = true
            self.datePicker.widthAnchor.constraint(equalTo: changeDateAlert.view.widthAnchor, constant: -10).isActive = true
            self.datePicker.centerYAnchor.constraint(equalTo: changeDateAlert.view.centerYAnchor).isActive = true
            
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
                let text = self.datePicker.date.toString(dateFormat: "dd-MM-yyyy")
                self.personsDayOfBirthdayTextLabel.text = text
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
            changeDateAlert.addAction(saveAction)
            changeDateAlert.addAction(cancelAction)
            self.present(changeDateAlert, animated: true, completion: nil)
        }))
        
        // Alert for deleting person
        settingsAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            let deleteAlert = UIAlertController(title: "You want to delete this person?", message: "", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self?.deletePerson()
                self?.navigationController?.popViewController(animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
            deleteAlert.addAction(acceptAction)
            deleteAlert.addAction(cancelAction)
            self?.present(deleteAlert, animated: true, completion: nil)
        }))
        
        settingsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        present(settingsAlert, animated: true, completion: nil)
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
    // MARK: Database functions
    func fetchPerson(){
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "id = %@", personID.uuidString)
        
        do {
            let results = try context.fetch(fetchRequest)
            person = results.first
        } catch {
            print("🔴Could not fetch: \(error.localizedDescription)")
        }
    }
    func updatePerson() {
        let context = appDelegate.persistentContainer.viewContext
        guard let _person = person else { return }
        
        _person.setValue(personsNameTextLabel.text, forKey: "name")
        _person.setValue(personsDayOfBirthdayTextLabel.text?.toDate(withFormat: "dd-MM-yyyy"), forKey: "dayOfBirthday")
        _person.setValue(personsPhoto.image?.jpegData(compressionQuality: 1), forKey: "image")
        
        do {
            try context.save()
        } catch {
            print("🔴Could not save while delete: \(error.localizedDescription)")
        }
    }
    func deletePerson() {
        let context = appDelegate.persistentContainer.viewContext
        guard let _person = person else { return }
        context.delete(_person)
        
        do {
            try context.save()
        } catch {
            print("🔴Could not save while delete: \(error.localizedDescription)")
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            personsPhoto.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Constraints
private extension DetailViewController {
    func addSubviews() {
        view.addSubview(personsPhoto)
        view.addSubview(personsNameView)
        personsNameView.addSubview(personsNameLabel)
        personsNameView.addSubview(personsNameTextLabel)
        view.addSubview(personsDayOfBirthdayView)
        personsDayOfBirthdayView.addSubview(personsDayOfBirthdayLabel)
        personsDayOfBirthdayView.addSubview(personsDayOfBirthdayTextLabel)
    }
    func setupLabelsConstriantsInView(mainView: UIView, leftLabel: UILabel, rightLabel: UILabel) {
        leftLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        leftLabel.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1/6).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor).isActive = true
        rightLabel.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 5/6).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
    func setupConstraints() {
        personsPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        personsPhoto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        personsPhoto.heightAnchor.constraint(equalTo: personsPhoto.widthAnchor).isActive = true
        personsPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCornerRadius(name: personsPhoto)
        
        personsNameView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        personsNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        personsNameView.topAnchor.constraint(equalTo: personsPhoto.bottomAnchor, constant: 20).isActive = true
        personsNameView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        addCornerRadius(name: personsNameView)
        setupLabelsConstriantsInView(mainView: personsNameView, leftLabel: personsNameLabel, rightLabel: personsNameTextLabel)

        personsDayOfBirthdayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        personsDayOfBirthdayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        personsDayOfBirthdayView.topAnchor.constraint(equalTo: personsNameView.bottomAnchor, constant: 20).isActive = true
        personsDayOfBirthdayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        addCornerRadius(name: personsDayOfBirthdayView)
        setupLabelsConstriantsInView(mainView: personsDayOfBirthdayView, leftLabel: personsDayOfBirthdayLabel, rightLabel: personsDayOfBirthdayTextLabel)
    }
}
