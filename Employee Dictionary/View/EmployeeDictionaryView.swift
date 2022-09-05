//
//  EmployeeDictionaryView.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/3.
//

import UIKit

class EmployeeDictionaryView: UIView {
    
    var navigationBar: UINavigationBar = {
        var view = UINavigationBar()
        return view
    }()
    
    var searchBar: UISearchBar = {
        var view = UISearchBar()
        view.placeholder = "Search employee"
        view.textContentType = .name
        view.searchBarStyle = .minimal
        return view
    }()
    
    var tableView: UITableView = {
        var view = UITableView()
        view.backgroundColor = .red
        view.register(EmployeeInfoTableViewCell.self, forCellReuseIdentifier: "EmployeeInfoTableViewCell")
        return view;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        self.backgroundColor = .systemBackground
       
        self.addSubview(self.navigationBar)
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let titleItem = UINavigationItem(title: NSLocalizedString("Employee Directory", comment: ""))
        self.navigationBar.setItems([titleItem], animated: false)
        
        self.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 13).isActive = true
        self.searchBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 37).isActive = true
        self.searchBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.83).isActive = true
        self.searchBar.delegate = self
        
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
}

extension EmployeeDictionaryView: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: Implement Search Function
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
    }
}

