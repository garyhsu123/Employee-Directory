//
//  EmployeeProfileViewModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/16.
//

import Foundation
import UIKit

class EmployeeProfileViewModel: NSObject {
    
    var uuid: String?
    var name: String?
    var team: String?
    var email: String?
    var phone: String?
    var photoUrlSmall: URL?
    var photoUrlLarge: URL?

    var fileModel: FileModel?
    
    init(employeeModel: Employee?) {
        self.uuid = employeeModel?.uuid
        self.name = employeeModel?.fullName
        self.team = employeeModel?.team
        self.email = employeeModel?.emailAddress
        self.phone = employeeModel?.phoneNumber
        self.photoUrlSmall = employeeModel?.photoUrlSmall
        self.photoUrlLarge = employeeModel?.photoUrlLarge
    }
}
