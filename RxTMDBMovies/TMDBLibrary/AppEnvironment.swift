//
//  AppEnvironment.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import TMDBApi

public struct AppEnvironment {
    
    fileprivate static var stack: [Environment] = [Environment()]
    
    // The most recent environment on the stack.
    public static var current: Environment! {
        return stack.last
    }
    
    public static func login(_ envelope: AccessTokenEnvelope) {
        replaceCurrentEnvironment(
            apiService: current.apiService.login(OauthTokenAuth(token: envelope.token))
        )
    }
    
    public static func updateServerConfig(_ config: ServiceConfigProtocol) {
        let service = TMDBService(serviceConfig: config)
        replaceCurrentEnvironment(apiService: service)
    }
    
    public static func replaceCurrentEnvironment(
        apiService: TMDBServiceProtocol = AppEnvironment.current.apiService,
        posterBaseURL: String = AppEnvironment.current.posterBaseURL
    ) {
        replaceCurrentEnvironment(
            Environment(
                apiService: apiService,
                posterBaseURL: posterBaseURL
            )
        )
    }
    
    public static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
    
    /// Push a new environment onto the stack
    public static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    public static func pushEnvironment(
        apiService: TMDBServiceProtocol = AppEnvironment.current.apiService
    ) {
        pushEnvironment(Environment(apiService: apiService))
    }
    
    @discardableResult
    public static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
}

