//
//  EmployeeDictionaryTestProtocol.swift
//  Employee DictionaryTests
//
//  Created by Yu-Chun Hsu on 2022/9/22.
//

import Foundation

protocol EmployeeDictionaryTestProtocol {
    associatedtype employeeViewModel
    
    var totalEmployeesCount: Int { get }
    var sectionIndexTitles: [String]? { get }
    func getViewModel(section: Int, index: Int) -> employeeViewModel
    func filter(with text: String)
}
