//
//  MainEndpoint.swift
//  TestSozluk
//
//  Created by Olgu Sırman on 10.07.2019.
//  Copyright © 2019 MesutGunes. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum ItunesAPI {
    case search
}

extension ItunesAPI: EndPointType {
    
    var environmentBaseURL : String {
        switch ItunesNetworkManager.environment {
        case .production, .qa, .staging: return "https://itunes.apple.com"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .search:
            #warning("Supply query request here")
            return .requestParameters(
                bodyParameters: ["term":"swift", "media":"podcast", "limit": 100],
                bodyEncoding: .urlEncoding,
                urlParameters: ["term":"swift", "media":"podcast", "limit": "100"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}

