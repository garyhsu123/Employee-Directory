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
    
    private var customView: EmployeeDictionaryView = {
        var view = EmployeeDictionaryView.init(frame: UIScreen.main.bounds)
        return view
    }()
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        self.customView.searchFilterClosure = { [weak self] searchText in
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
                self.customView.tableView.reloadData()
            }
        })
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
        self.customView.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {

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
        self.customView.searchBar.resignFirstResponder()
        if let cancelButton = self.customView.searchBar.value(forKey: "cancelButton") as? UIButton {
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
        self.customView.searchBar.resignFirstResponder()
        if let cancelButton = self.customView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        
    }
}
