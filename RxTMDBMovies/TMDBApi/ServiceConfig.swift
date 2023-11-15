//
//  ServiceConfig.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

public protocol ServiceConfigProtocol {
    var apiBaseURL: URL { get }
}


public struct ServiceConfig: ServiceConfigProtocol {
    
    public var apiBaseURL: URL
    
    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }
    
    public static let production: ServiceConfigProtocol = ServiceConfig(
        apiBaseURL: URL(string: "https://api.themoviedb.org")!
    )
}
