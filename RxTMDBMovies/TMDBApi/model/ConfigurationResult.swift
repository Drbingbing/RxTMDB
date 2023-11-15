//
//  ConfigurationResult.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

struct ConfigurationResult: Decodable {
    
    public let result: ImagesConfiguration
    
    private enum CodingKeys: String, CodingKey {
        case result = "images"
    }
}
