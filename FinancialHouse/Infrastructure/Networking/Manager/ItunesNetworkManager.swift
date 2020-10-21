//
//  ItunesNetworkManager.swift
//  NetworkLayer
//
//  Created by Olgu SIRMAN on 2018/03/11.
//  Copyright © 2018 Olgu SIRMAN. All rights reserved.
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
    case cannotDelete
    case cannotDeleteId
    
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
        case .cannotDelete: return "There is an error while deleting this item"
        case .cannotDeleteId: return "There is no deleted item id"
        }
    }
}

//enum Result<String> {
//    case success
//    case failure(ItunesNetworkError)
//}

struct ItunesNetworkManager: MediasStoreProtocol {
    static let environment: NetworkEnvironment = .production
    
    let router = Router<ItunesAPI>()
    var decoder: JSONDecoder {
        newJSONDecoder()
    }
    
    func fetchMedias(request: Medias.FetchMedias.Request,
                     completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
        router.request(.search(term: request.term, media: request.media.rawValue)) { data, response, error in
            
            if error != nil {
                completionHandler(nil, ItunesNetworkError.network)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = response.handleNetworkResponse()
                switch result {
                case .success:
                    guard let responseData = data else {
                        completionHandler(nil, ItunesNetworkError.noData)
                        return
                    }
                    do {
                        let apiResponse = try decoder.decode(ItunesMainData.self, from: responseData)
                        completionHandler(apiResponse.results, nil)
                    } catch {
                        completionHandler(nil, ItunesNetworkError.decoding)
                    }
                case .failure(let networkFailureError):
                    completionHandler(nil, networkFailureError)
                }
            }
        }
    }
    
    func deleteMedia(request: Medias.DeleteMedia.Request, completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
        // No API for this
    }
}

private extension HTTPURLResponse {
    func handleNetworkResponse() -> Result<Any?, ItunesNetworkError> {
        switch statusCode {
        case 200...299: return .success(nil)
        case 401...500: return .failure(ItunesNetworkError.authenticationError)
        case 501...599: return .failure(ItunesNetworkError.badRequest)
        case 600: return .failure(ItunesNetworkError.outdated)
        default: return .failure(ItunesNetworkError.failed)
        }
    }
}
