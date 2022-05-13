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
    
    let tableView = UITableView()
    
    var persons:[Person] = []
    
    let filterPersonsClass = FilterForPersons.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Birthdays Table"
        
        launchAddButton()
        launchFilterButton()
        
        addSubviews()
        setupTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            PersonsCoreDataManager.shared.fetchPersons { [weak self] result in
                switch result {
                case .success(let _persons):
                    self?.persons = _persons
                case .failure(let error):
                    print(error)
                }
            }
            self.persons = self.filterPersonsClass.checkingWhichFilter(persons: self.persons)
            self.tableView.reloadData()
            if self.persons.first != nil {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
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
    
    func launchFilterButton() {
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                                           style: .done,
                                           target: self,
                                           action: #selector(didTapFilterButton))
        self.navigationItem.leftBarButtonItem = filterButton
    }
    
    @objc func didTapFilterButton() {
        let filterAlert = UIAlertController(title: "Filter", message: "Sort by", preferredStyle: .actionSheet)
        let byNameAction = UIAlertAction(title: "Name", style: .default, handler: { [weak self] (alert) in
            guard let self = self else { return }
            
            self.persons = self.filterPersonsClass.filterPersonsByName(persons: self.persons)
            self.filterPersonsClass.userDefaults.set(FilterForPersons.Filters.byName, forKey: FilterForPersons.FiltersKeys.filteredBy)
            self.tableView.reloadData()
        })
        let byAgeAction = UIAlertAction(title: "Age", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.persons = self.filterPersonsClass.filterPersonsByAge(persons: self.persons)
            self.filterPersonsClass.userDefaults.set(FilterForPersons.Filters.byAge, forKey: FilterForPersons.FiltersKeys.filteredBy)
            self.tableView.reloadData()
        })
        let byDayOfBirthdayAction = UIAlertAction(title: "Day of Birthday", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.persons = self.filterPersonsClass.filterPersonsByDayOfBirthday(persons: self.persons)
            self.filterPersonsClass.userDefaults.set(FilterForPersons.Filters.byDayOfBirthday, forKey: FilterForPersons.FiltersKeys.filteredBy)
            self.tableView.reloadData()
        })
        filterAlert.addAction(byNameAction)
        filterAlert.addAction(byAgeAction)
        filterAlert.addAction(byDayOfBirthdayAction)
        filterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        self.present(filterAlert, animated: true, completion: nil)
    }
}

    // MARK: - Table view data source
extension TableOfBirthdaysViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        let _persons = persons[indexPath.row]
        cell.updateUI(person: _persons)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersonsCoreDataManager.shared.deletePersons(personsArray: persons, atIndexPath: indexPath)
            PersonsCoreDataManager.shared.fetchPersons { [weak self] result in
                switch result {
                case .success(let _persons):
                    self?.persons = _persons
                case .failure(let error):
                    print(error)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        guard let personsId = persons[indexPath.row].id else { return }
        detailViewController.personID = personsId
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
    // MARK: Constraints
private extension TableOfBirthdaysViewController {
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
