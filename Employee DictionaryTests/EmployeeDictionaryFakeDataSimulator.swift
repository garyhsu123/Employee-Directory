//
//  DummyNetwork.swift
//  Employee DictionaryTests
//
//  Created by Yu-Chun Hsu on 2022/9/21.
//

import Foundation
@testable import Employee_Dictionary

class EmployeeDictionaryFakeDataSimulator: NSObject, NetworkProtocol, EmployeeDictionaryTestProtocol {
    
    var sectionIndexTitles: [String]? {
        get {
            return groupedEmployeesData?.compactMap {
                guard let c = $0.0 else {
                    return nil
                }
                return String(c)
            }
        }
    }
    
    fileprivate var groupedEmployeesData: [(String.Element?,[Employee])]?
    fileprivate var rawGroupedEmployeesData: [(String.Element?,[Employee])]?
    
    var totalEmployeesCount: Int {
        get {
            return groupedEmployeesData?.reduce(0, {$0 + $1.1.count}) ?? 0
        }
    }
    
    fileprivate var fakeEmployees: [Employee] = []
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY"
    func randomString(length: Int) -> String {
      
      return String([length].map{ _ in letters.randomElement()! })
    }
    
    func requestJsonData<T>(requestUrl: URL?, decodeModel: T.Type, completion: ((T?) -> ())?) throws where T : Decodable {
        
        if T.self != CompanyData.self {
            throw NetworkError.decodeFail
        }
        
        for _ in 0..<10 {
            let fullName = randomString(length: Int(arc4random()) % 10 + 8)
            
            let employee = Employee(uuid: UUID().uuidString, fullName: fullName, phoneNumber: "123456789", emailAddress: "test@test.com", biography: "Hello, I am \(fullName)", photoUrlSmall: URL(string: "https://media.istockphoto.com/photos/portrait-of-a-confident-mature-businessman-working-in-a-modern-office-picture-id1314997483?b=1&k=20&m=1314997483&s=170667a&w=0&h=BEv_GbGsL0A3ry-v5ouQbsn4xGokAD2DxXRWFaxpRjs=")!, photoUrlLarge: URL(string: "https://e9g2x6t2.rocketcdn.me/wp-content/uploads/2020/11/Professional-Headshot-Poses-Blog-Post.jpg")!, team: "Random Team", employeeType: "Full-Time")
            fakeEmployees.append(employee)
        }
        
        var groupedEmployees = Dictionary(grouping: fakeEmployees, by: { employee in
            return employee.fullName.uppercased().first
        }).sorted { $0.key! <= $1.key!}
        
        
        for (idx, (charKey,unsortedEmployees)) in groupedEmployees.enumerated() {
            groupedEmployees[idx] = (charKey, unsortedEmployees.sorted { $0.fullName < $1.fullName
            })
        }
        
        self.groupedEmployeesData = groupedEmployees
        self.rawGroupedEmployeesData = groupedEmployees
        
        completion?(CompanyData(employees: fakeEmployees) as? T)
    }
    
    func getViewModel(section: Int, index: Int) -> EmployeeProfileViewModel {
        return EmployeeProfileViewModel(employeeModel: self.groupedEmployeesData?[section].1[index])
    }
    
    func filter(with text: String) {
        if text.isEmpty {
            self.groupedEmployeesData = self.rawGroupedEmployeesData
            return
        }
        
        self.groupedEmployeesData = self.rawGroupedEmployeesData?.compactMap { data in
            
            var matchEmployee: [Employee] = []
            let regularExpression = try? NSRegularExpression(pattern: "[a-zA-Z]*\(text.lowercased())[a-zA-Z]*", options: .caseInsensitive)
            
            for employee in data.1 {
                
                
                let range = NSRange(location: 0, length: employee.fullName.utf16.count)
                
                let result = regularExpression?.matches(in: employee.fullName.lowercased(), range: range)
                
                guard let result = result else {
                    continue
                }

                if !result.isEmpty {
                    matchEmployee.append(employee)
                }
            }
            
            if matchEmployee.isEmpty {
                return nil
            }
            else {
                return (data.0, matchEmployee)
            }
            
        }
    }
}
