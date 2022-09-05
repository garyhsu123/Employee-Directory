//
//  Network.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import Foundation
import Combine

enum NetworkError: Error {
    case urlError
}

class Network: NSObject {
    
  
    var cancellable: Cancellable?
    
    func requestJsonData<T: Decodable>(requestUrl: URL?, jsonModel: T.Type, completion: ((_ response: T?) -> ())?) throws {
        
        guard let requestUrl = requestUrl else {
            throw NetworkError.urlError
        }
 
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // TODO: Error Handling
        cancellable = URLSession.shared
            .dataTaskPublisher(for: requestUrl)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { decodedData in
                if let completion = completion {
                    completion(decodedData)
                }
            })
        
    }
}
