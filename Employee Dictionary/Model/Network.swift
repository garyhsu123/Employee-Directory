//
//  Network.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import Foundation
import Combine

enum NetworkError: Error {
    case decodeFail
    case urlError
}

protocol NetworkProtocol {
    func requestJsonData<T: Decodable>(requestUrl: URL?, decodeModel: T.Type, completion: ((_ response: T?) -> ())?) throws
}

class HTTPNetwork: NSObject, NetworkProtocol {
    
  
    var cancellable: Cancellable?
    
    func requestJsonData<T: Decodable>(requestUrl: URL?, decodeModel: T.Type, completion: ((_ response: T?) -> ())?) throws {
        
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
