//
//  TMDBService.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import RxCocoa

public struct TMDBService: TMDBServiceProtocol {
    
    public var serviceConfig: ServiceConfigProtocol
    public var oauthToken: OauthTokenAuthProtocol?
    
    public init(
        serviceConfig: ServiceConfigProtocol = ServiceConfig.production,
        oauthToken: OauthTokenAuthProtocol? = nil
    ) {
        self.serviceConfig = serviceConfig
        self.oauthToken = oauthToken
    }
    
    public func login(_ oauthToken: OauthTokenAuthProtocol) -> TMDBService {
        return TMDBService(serviceConfig: serviceConfig, oauthToken: oauthToken)
    }

    public func configuration() -> Signal<Result<ImagesConfiguration, ErrorEnvelope>> {
        let result: Signal<Result<ConfigurationResult, ErrorEnvelope>> = request(.configuration)
        return result.map {
            $0.map(\.result)
        }
    }
}
