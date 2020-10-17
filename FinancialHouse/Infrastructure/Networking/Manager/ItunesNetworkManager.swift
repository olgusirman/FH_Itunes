//
//  ItunesNetworkManager.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum ItunesNetworkError: Error {
    
    case unknown
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case decoding
    case network

    var errorDescription: String {
        switch self {
        case .unknown: return "Some unknown error happened"
        case .authenticationError: return "You need to be authenticated first."
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .failed: return "Network request failed."
        case .noData: return "Response returned with no data to decode."
        case .decoding: return "We could not decode the response."
        case .network: return "Please check your network connection."
        }
    }
    
}

enum Result<String>{
    case success
    case failure(ItunesNetworkError)
}

struct ItunesNetworkManager {
    static let environment: NetworkEnvironment = .production
    
    let router = Router<ItunesAPI>()
    var decoder: JSONDecoder {
        newJSONDecoder()
    }
    
    func searchMedia(completion: @escaping (_ items: [ItunesItem]?, _ error: ItunesNetworkError?) -> Void ) {
        router.request(.search) { data, response, error in
            
            if error != nil {
                completion(nil, ItunesNetworkError.network)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, ItunesNetworkError.noData)
                        return
                    }
                    do {
                       let apiResponse = try decoder.decode(ItunesMainData.self, from: responseData)
                        completion(apiResponse.results, nil)
                    } catch {
                        completion(nil, ItunesNetworkError.decoding)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
}

fileprivate extension HTTPURLResponse {
    
    func handleNetworkResponse() -> Result<String>{
        switch statusCode {
        case 200...299: return .success
        case 401...500: return .failure(ItunesNetworkError.authenticationError)
        case 501...599: return .failure(ItunesNetworkError.badRequest)
        case 600: return .failure(ItunesNetworkError.outdated)
        default: return .failure(ItunesNetworkError.failed)
        }
    }
    
}