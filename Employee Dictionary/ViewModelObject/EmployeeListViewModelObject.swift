//
//  EmployeeListViewModelObject.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/20.
//

import Foundation

class EmployeeListViewModelObject: EmployeeListViewModel {
    
    fileprivate var groupedEmployeesData: [(String.Element?,[Employee])]?
    fileprivate var rawGroupedEmployeesData: [(String.Element?,[Employee])]?
    fileprivate var network: NetworkProtocol?
    fileprivate var fileModel: FileModel?
    
    var sectionCount: Int {
        get {
            return self.groupedEmployeesData?.count ?? 0
        }
         
        set {
            self.sectionCount = newValue
        }
    }
    
    var sectionIndexTitles: [String]? {
        get {
            return self.groupedEmployeesData?.compactMap({ String($0.0!)
            })
        }
    }
    
    init(network: NetworkProtocol, fileModel: FileModel? = nil) {
        self.network = network
        self.fileModel = fileModel
    }
    
    func requestData(url: URL?, decodeModel: CompanyData.Type, completion: (() -> ())? = nil) throws {
        try? self.network?.requestJsonData(requestUrl: url, decodeModel: decodeModel.self, completion: { [weak self] response in
            
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
            
            self?.groupedEmployeesData = groupedEmployees
            self?.rawGroupedEmployeesData = groupedEmployees
            completion?()
        })
    }
    
    func getViewModel(section: Int, index: Int) -> EmployeeProfileViewModel {
        return EmployeeProfileViewModel(employeeModel: self.groupedEmployeesData?[section].1[index], fileModel: fileModel)
    }
    
    func count(section: Int) -> Int {
        self.groupedEmployeesData?[section].1.count ?? 0
    }
    
    func getTitle(section: Int) -> String? {
        if let char = self.groupedEmployeesData?[section].0 {
            return String(char)
        }
        return ""
    }
    
    func filter(with text: String) {
        if text.count == 0 {
            self.groupedEmployeesData = self.rawGroupedEmployeesData
        }
        else {
            self.groupedEmployeesData = self.rawGroupedEmployeesData?.compactMap{ data in
                var nameIcludesSearchText: [Employee] = []
                for employee in data.1 {
                    if (employee.fullName.lowercased().contains(text.lowercased())) {
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
    }
}
