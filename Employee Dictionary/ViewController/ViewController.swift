//
//  ViewController.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    lazy var employeeDetailVC = EmployeeDetailViewController()
    var employeeListViewModel = EmployeeListViewModelObject(network: HTTPNetwork(), fileModel: FileModel())
    
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
    
    var plainView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        return view
    }()
    
    var indicatorView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    var tableView: UITableView = {
        var view = UITableView()
        view.backgroundColor = .red
        view.register(EmployeeInfoTableViewCell.self, forCellReuseIdentifier: "EmployeeInfoTableViewCell")
        view.showsVerticalScrollIndicator = false
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configUI()
        
        try? self.employeeListViewModel.requestData(url: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json"), decodeModel: CompanyData.self) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func configUI() {
        self.view.backgroundColor = .systemBackground
       
        self.view.addSubview(self.navigationBar)
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let titleItem = UINavigationItem(title: NSLocalizedString("Employee Directory", comment: ""))
        self.navigationBar.setItems([titleItem], animated: false)
        
        self.view.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 13).isActive = true
        self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 37).isActive = true
        self.searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.83).isActive = true
        self.searchBar.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.plainView)
        self.plainView.translatesAutoresizingMaskIntoConstraints = false
        self.plainView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10).isActive = true
        self.plainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.plainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        self.plainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        self.plainView.addSubview(self.indicatorView)
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.centerYAnchor.constraint(equalTo: self.plainView.centerYAnchor).isActive = true
        self.indicatorView.centerXAnchor.constraint(equalTo: self.plainView.centerXAnchor).isActive = true
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeInfoTableViewCell", for: indexPath) as! EmployeeInfoTableViewCell
        
        cell.didClickEmailClosure = { alertVC in
            self.present(alertVC, animated: true)
        }
        cell.employeeProfileViewModel = self.employeeListViewModel.getViewModel(section: indexPath.section, index: indexPath.item)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeListViewModel.count(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return employeeListViewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.employeeListViewModel.getTitle(section: section)
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeDetailVC.employeeProfileViewModel = self.employeeListViewModel.getViewModel(section: indexPath.section, index: indexPath.item)
        self.searchBar.resignFirstResponder()
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        self.navigationController?.present(employeeDetailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return employeeListViewModel.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}

extension ViewController: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.employeeListViewModel.filter(with: searchText)
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.resignFirstResponder()
    }
}
