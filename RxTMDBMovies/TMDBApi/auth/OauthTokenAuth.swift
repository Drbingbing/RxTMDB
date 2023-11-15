//
//  OauthTokenAuth.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

public protocol OauthTokenAuthProtocol {
    var token: String { get }
}

public func == (lhs: OauthTokenAuthProtocol, rhs: OauthTokenAuthProtocol) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs.token == rhs.token
}

public func == (lhs: OauthTokenAuthProtocol?, rhs: OauthTokenAuthProtocol?) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs?.token == rhs?.token
}

public struct OauthTokenAuth: OauthTokenAuthProtocol {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
}
