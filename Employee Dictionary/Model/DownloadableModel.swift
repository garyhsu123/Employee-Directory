//
//  DownloadableModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/27.
//

import Foundation
import UIKit

protocol DownloadableModel {
    associatedtype ItemType
    
    var downloadUrl: URL? { get }
    var finishDownload: ((ItemType?) -> ())? { get }
    init(downloadUrl: URL?, finishDownload: ((ItemType?) -> Void)?)
    func download() -> ItemType?
}

protocol ImageDownloadableModel: DownloadableModel {
    var downloadUrl: URL? { get }
    var finishDownload: ((UIImage?) -> ())? { get }
    init(downloadUrl: URL?, finishDownload: ((UIImage?) -> Void)?)
    func download() -> UIImage?
}

class ImageDownloadableObject: ImageDownloadableModel {
    
    var downloadUrl: URL?
    var finishDownload: ((UIImage?) -> ())?
    
    required init(downloadUrl: URL?, finishDownload: ((UIImage?) -> Void)? = nil) {
        self.downloadUrl = downloadUrl
        self.finishDownload = finishDownload
    }
    
    func download() -> UIImage? {
        guard let downloadUrl = self.downloadUrl, let data = try? Data(contentsOf: downloadUrl), let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
