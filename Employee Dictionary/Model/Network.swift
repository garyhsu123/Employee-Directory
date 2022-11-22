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
    case unKnown
}

protocol NetworkProtocol {
    func requestJsonData<T>(requestUrl: URL, decodeModel: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) where T : Codable
}

class HTTPNetwork: NSObject, NetworkProtocol {
    
  
    var cancellable: Cancellable?
    func requestJsonData<T>(requestUrl: URL, decodeModel: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) where T : Codable {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: requestUrl)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let err):
                        if err is DecodingError {
                            completion(.failure(.decodeFail))
                        }
                        else {
                            completion(.failure(.unKnown))
                        }
                }
            }, receiveValue: { decodedData in
                completion(.success(decodedData))
            })
        
    }
}
