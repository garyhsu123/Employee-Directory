//
//  DummyNetwork.swift
//  Employee DictionaryTests
//
//  Created by Yu-Chun Hsu on 2022/9/21.
//

import Foundation
@testable import Employee_Dictionary

class DummyNetwork: NSObject, NetworkProtocol {
    
    var expectedCount: Int {
        get {
            return 10
        }
    }
    
    fileprivate var fakeEmployees: [Employee] = []
    
    let letters = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY"
    func randomString(length: Int) -> String {
      
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func requestJsonData<T>(requestUrl: URL?, decodeModel: T.Type, completion: ((T?) -> ())?) throws where T : Decodable {
        
        if T.self != CompanyData.self {
            throw NetworkError.decodeFail
        }
        
        for _ in 0..<expectedCount {
            let fullName = randomString(length: Int(arc4random()) % 10 + 8)
            
            let employee = Employee(uuid: UUID().uuidString, fullName: fullName, phoneNumber: "123456789", emailAddress: "test@test.com", biography: "Hello, I am \(fullName)", photoUrlSmall: URL(string: "https://media.istockphoto.com/photos/portrait-of-a-confident-mature-businessman-working-in-a-modern-office-picture-id1314997483?b=1&k=20&m=1314997483&s=170667a&w=0&h=BEv_GbGsL0A3ry-v5ouQbsn4xGokAD2DxXRWFaxpRjs=")!, photoUrlLarge: URL(string: "https://e9g2x6t2.rocketcdn.me/wp-content/uploads/2020/11/Professional-Headshot-Poses-Blog-Post.jpg")!, team: "Random Team", employeeType: "Full-Time")
            fakeEmployees.append(employee)
        }
        
        completion?(CompanyData(employees: fakeEmployees) as? T)
    }
}
