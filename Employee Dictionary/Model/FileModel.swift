//
//  FileModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import Foundation
import UIKit

let EMPLOYEE_AVATAR_DIR = "Avatar"
//let employee
let DAY = 24.0 * 60 * 60

class FileModel {
    
    private static func DirectoryPath() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("EmployeeDictionary")
    }
    
    private func savePhoto(image: UIImage, imageUrl:URL, uuid: String) {
        guard let directoryPath = FileModel.DirectoryPath() else {
            return
        }
        
        let jpegData = image.jpegData(compressionQuality: 0.7)
        let filePath = directoryPath.appendingPathComponent(uuid).appendingPathComponent(imageUrl.lastPathComponent)
        try? FileManager.default.createDirectory(at: directoryPath.appendingPathComponent(uuid), withIntermediateDirectories: true)
        try? jpegData?.write(to: filePath)
    }
    
    private func getPhoto(imageUrl: URL, uuid: String) -> UIImage? {
        guard let directoryPath = FileModel.DirectoryPath() else {
            return nil
        }
        
        let filePath = directoryPath.appendingPathComponent(uuid).appendingPathComponent(imageUrl.lastPathComponent)
        
        if !FileManager.default.fileExists(atPath: filePath.path) {
            return nil
        }
        
        guard let imageData = try? Data(contentsOf: filePath) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func getPhoto(with imageUrl: URL, uuid: String) -> UIImage? {
        
        if let date = UserDefaults.standard.object(forKey: imageUrl.path), let timeStamp = date as? Double, Date.now.timeIntervalSince1970 - timeStamp < DAY, let image = getPhoto(imageUrl: imageUrl, uuid: uuid) {
            
            return image
        }
        return nil
    }
    
    func savePhoto(with image: UIImage, imageUrl:URL, uuid: String) {
        savePhoto(image: image, imageUrl: imageUrl, uuid: uuid)
        UserDefaults.standard.set(NSNumber(value: Date.now.timeIntervalSince1970), forKey: imageUrl.path)
    }
}
