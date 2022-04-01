//
//  TableOfBirthdaysViewController.swift
//  Birthday Reminder
//
//  Created by Kavaleuski Ivan on 11/01/2022.
//

import UIKit
import Foundation
import CoreData

class TableOfBirthdaysViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableView = UITableView()
    
    var persons:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Birthdays Table"
        
        launchAddButton()
        
        addSubviews()
        setupTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.fetchPersons()
            self.tableView.reloadData()
        }
    }
    
    func launchAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAddButton() {
        let addingBirthdayVC = AddingBirthdayViewController()
        navigationController?.pushViewController(addingBirthdayVC, animated: true)
    }

    func fetchPersons() {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        do {
            persons = try context.fetch(fetchRequest)
        } catch {
            print("🔴Could not fetch: \(error.localizedDescription)")
        }
    }
    func deletePersons(atIndexPath indexPath: IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(persons[indexPath.row])
        
        do {
            try context.save()
        } catch {
            print("🔴Could not save while delete: \(error.localizedDescription)")
        }
    }
}

// MARK: - Table view data source
extension TableOfBirthdaysViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        let _persons = persons[indexPath.row]
        cell.updateUI(person: _persons)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deletePersons(atIndexPath: indexPath)
            self.fetchPersons()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.person = persons[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
    // MARK: Constraints
extension TableOfBirthdaysViewController {
    func addSubviews() {
        view.addSubview(tableView)
    }
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
