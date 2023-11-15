//
//  Route.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

internal enum Route {
    
    case configuration
    case upcoming([String: Any])
    
    internal var requestProperties: (method: Method, path: String, query: [String: Any]) {
        switch self {
        case .configuration:
            return (.GET, "/3/configuration", [:])
        case let .upcoming(params):
            return (.GET, "/3/movie/upcoming", params)
        }
    }
}
