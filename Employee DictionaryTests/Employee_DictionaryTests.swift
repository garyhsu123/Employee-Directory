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
    var dummyNetwork: DummyNetwork!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        dummyNetwork = DummyNetwork()
        employeeProfileViewModel = EmployeeListViewModelObject(network: dummyNetwork)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dummyNetwork = nil
        employeeProfileViewModel = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testTotalNumberOfEmployees() {
        try? employeeProfileViewModel.requestData(url: nil, decodeModel: CompanyData.self)
        var totalEmployees = 0
        
        for i in 0 ..< employeeProfileViewModel.sectionCount {
            totalEmployees += employeeProfileViewModel.count(section: i)
        }
        
        XCTAssertEqual(totalEmployees, dummyNetwork.expectedCount)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
