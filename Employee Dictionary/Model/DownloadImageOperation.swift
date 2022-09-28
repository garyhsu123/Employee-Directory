//
//  DownloadImageOperation.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/27.
//

import Foundation
import UIKit

class DownloadImageOperation: Operation {
    let downloadableObject: any ImageDownloadableModel
    
    init(downloadableObject: any ImageDownloadableModel) {
        self.downloadableObject = downloadableObject
        super.init()
    }
    
    override func main() {
        super.main()
        
        if self.isCancelled {
            return
        }
        
        let downloadedItem = downloadableObject.download()
        
        if self.isCancelled {
            return
        }
        
        downloadableObject.finishDownload?(downloadedItem)
    }
}
