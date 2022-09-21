//
//  ViewController.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    lazy var network = Network()
    lazy var fileModel = FileModel()
    lazy var employeeDetailVC = EmployeeDetailViewController()
    var groupedEmployeesData:[(String.Element?,[Employee])]?
    var rawGroupedEmployeesData:[(String.Element?,[Employee])]?
    
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
    
    var searchFilterClosure:((_ searchText: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configUI()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchFilterClosure = { [weak self] searchText in
            self?.filterEmployeesData(with: searchText)
        }
        
        try? self.network.requestJsonData(requestUrl: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json"), jsonModel: CompanyData.self, completion: { response in

            
            
            guard let employees = response?.employees else {
                return
            }
            
            var groupedEmployees = Dictionary(grouping: employees, by: { employee in
                return employee.fullName.first
            }).sorted { $0.key! <= $1.key!}
            
            
            for (idx, (charKey,unsortedEmployees)) in groupedEmployees.enumerated() {
                groupedEmployees[idx] = (charKey, unsortedEmployees.sorted { $0.fullName < $1.fullName
                })
            }
            
            self.groupedEmployeesData = groupedEmployees
            self.rawGroupedEmployeesData = groupedEmployees
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
    
    func filterEmployeesData(with searchText: String) {
       
        if searchText.count == 0 {
            self.groupedEmployeesData = self.rawGroupedEmployeesData
        }
        else {
            self.groupedEmployeesData = self.rawGroupedEmployeesData?.compactMap{ data in
                var nameIcludesSearchText: [Employee] = []
                for employee in data.1 {
                    if (employee.fullName.lowercased().contains(searchText.lowercased())) {
                        nameIcludesSearchText.append(employee)
                    }
                }
                if (nameIcludesSearchText.isEmpty) {
                    return nil
                }
                else {
                    return (data.0, nameIcludesSearchText)
                }
            }
        }
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let employeeInfoTableViewCell = cell as? EmployeeInfoTableViewCell else {
            return
        }
        employeeInfoTableViewCell.headShotImageView.layer.cornerRadius = employeeInfoTableViewCell.headShotImageView.bounds.height/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeInfoTableViewCell", for: indexPath) as! EmployeeInfoTableViewCell
        
        let model =  groupedEmployeesData?[indexPath.section].1[indexPath.item]
        
        let employeeProfileViewModel = EmployeeProfileViewModel(employeeModel: model)
        employeeProfileViewModel.fileModel = self.fileModel
        
        cell.didClickEmailClosure = { alertVC in
            self.present(alertVC, animated: true)
        }
        cell.employeeProfileViewModel = employeeProfileViewModel
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.groupedEmployeesData?[section].1.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedEmployeesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let char = self.groupedEmployeesData?[section].0 {
            return String(char)
        }
        return ""
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeDetailVC.fileModel = self.fileModel
        
        let model =  groupedEmployeesData?[indexPath.section].1[indexPath.item]
        let employeeProfileViewModel = EmployeeProfileViewModel(employeeModel: model)
        
        employeeDetailVC.employeeProfileViewModel = employeeProfileViewModel
        self.searchBar.resignFirstResponder()
        if let cancelButton = self.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        self.navigationController?.present(employeeDetailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.groupedEmployeesData?.compactMap({ String($0.0!)
        })
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
        // TODO: Implement Search Function
        guard let searchFilterClosure = self.searchFilterClosure else {
            return
        }
        searchFilterClosure(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.resignFirstResponder()
    }
}
