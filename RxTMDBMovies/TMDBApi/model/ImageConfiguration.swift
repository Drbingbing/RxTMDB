//
//  ImagesConfiguration.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

public struct ImagesConfiguration: Decodable {
    
    public var baseURL: String
    public var posterSizes: [String]
    
    public init(baseURL: String, posterSizes: [String]) {
        self.baseURL = baseURL
        self.posterSizes = posterSizes
    }
    
    private enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case posterSizes = "poster_sizes"
    }
}
