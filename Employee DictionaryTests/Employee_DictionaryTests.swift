//
//  Employee_DictionaryTests.swift
//  Employee DictionaryTests
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import XCTest
@testable import Employee_Dictionary

class Employee_DictionaryTests: XCTestCase {

    var employeeProfileViewModel: EmployeeListViewModelObject!
    var employeeDictionaryFakeDataSimulator: EmployeeDictionaryFakeDataSimulator!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        employeeDictionaryFakeDataSimulator = EmployeeDictionaryFakeDataSimulator()
        employeeProfileViewModel = EmployeeListViewModelObject(network: employeeDictionaryFakeDataSimulator)
        employeeProfileViewModel.requestData(url: URL.init(string: "https://")!, decodeModel: CompanyData.self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        employeeDictionaryFakeDataSimulator = nil
        employeeProfileViewModel = nil
        try super.tearDownWithError()
    }

    func testSearch() throws {
        let filterText = "c"
        employeeProfileViewModel.filter(with: filterText)
        employeeDictionaryFakeDataSimulator.filter(with: filterText)
        
        XCTAssertEqual(employeeDictionaryFakeDataSimulator.sectionIndexTitles, employeeProfileViewModel.sectionIndexTitles)
        
        for section in 0..<employeeProfileViewModel.sectionCount {
            for index in 0..<employeeProfileViewModel.count(section: section) {
                XCTAssertEqual(employeeDictionaryFakeDataSimulator.getViewModel(section: section, index: index), employeeProfileViewModel.getViewModel(section: section, index: index))
            }
        }
        employeeProfileViewModel.filter(with: "")
        employeeDictionaryFakeDataSimulator.filter(with: "")
    }
    
    func testSectionIndexTitles() throws {
        XCTAssertEqual(employeeDictionaryFakeDataSimulator.sectionIndexTitles, employeeProfileViewModel.sectionIndexTitles)
    }

    func testTotalNumberOfEmployees() {
        
        var totalEmployees = 0
        
        for i in 0 ..< employeeProfileViewModel.sectionCount {
            totalEmployees += employeeProfileViewModel.count(section: i)
        }
        
        XCTAssertEqual(totalEmployees, employeeDictionaryFakeDataSimulator.totalEmployeesCount)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
