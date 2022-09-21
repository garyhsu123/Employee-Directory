//
//  EmployeeProfileViewModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/16.
//

import Foundation
import UIKit

struct EmployeeProfileViewModel {
    
    var uuid: String?
    var name: String?
    var team: String?
    var email: String?
    var phone: String?
    var photoUrlSmall: URL?
    var photoUrlLarge: URL?
    var biography: String?
    
    var fileModel: FileModel?
    
    init(employeeModel: Employee?, fileModel: FileModel? = nil) {
        self.uuid = employeeModel?.uuid
        self.name = employeeModel?.fullName
        self.team = employeeModel?.team
        self.email = employeeModel?.emailAddress
        self.phone = employeeModel?.phoneNumber
        self.photoUrlSmall = employeeModel?.photoUrlSmall
        self.photoUrlLarge = employeeModel?.photoUrlLarge
        self.biography = employeeModel?.biography
        
        self.fileModel = fileModel
    }
    
    func getPhoto(with photoUrl: URL?, completion: @escaping ((UIImage?) -> ())) {
        guard let photoUrl = photoUrl, let uuid = self.uuid else {
            completion(nil)
            return
        }
        
        
        if let image = fileModel?.getPhoto(with: photoUrl, uuid: uuid) {
            completion(image)
        }
        else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: photoUrl), let image = UIImage(data: data) {
                    self.fileModel?.savePhoto(with: image, imageUrl: photoUrl, uuid: uuid)
                    completion(image)
                }
                
            }
        }
    }
}
