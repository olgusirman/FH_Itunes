//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Olgu SIRMAN on 2018/03/05.
//  Copyright © 2018 Olgu SIRMAN. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

