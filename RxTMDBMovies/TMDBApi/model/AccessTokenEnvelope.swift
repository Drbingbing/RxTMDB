//
//  AccessTokenEnvelope.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

public struct AccessTokenEnvelope: Decodable {
    public var token: String
    
    public init(token: String) {
        self.token = token
    }
    
    private enum CodingKeys: String, CodingKey {
        case token = "Bearer Token"
    }
}
