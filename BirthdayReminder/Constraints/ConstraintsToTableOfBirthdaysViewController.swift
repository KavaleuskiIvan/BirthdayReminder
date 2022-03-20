//
//  ConstraintsToTableOfBirthdaysViewController.swift
//  BirthdayReminder
//
//  Created by Kavaleuski Ivan on 19/03/2022.
//

import Foundation

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
