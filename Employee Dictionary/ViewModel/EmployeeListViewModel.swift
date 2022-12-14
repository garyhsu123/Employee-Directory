//
//  EmployeeListViewModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/20.
//

import Foundation

protocol EmployeeListViewModel: AnyObject {
    
    associatedtype decodeModel: Decodable
    associatedtype employeeViewModel
    
    var sectionCount: Int { get }
    var sectionIndexTitles: [String]? { get }
    var searxchText: String { get }
    
    func count(section: Int) -> Int
    func requestData(url: URL, decodeModel: decodeModel.Type, completion: ((Bool) -> ())?) throws
    func getViewModel(section: Int, index: Int) -> employeeViewModel
    func getTitle(section: Int) -> String?
    func filter(with text: String?)
}
