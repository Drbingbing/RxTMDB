//
//  Service+Helpers.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import RxCocoa

extension TMDBService {
    
    private static let session = URLSession(configuration: .default)

    func request<M: Decodable>(_ route: Route) -> Signal<Result<M, ErrorEnvelope>> {
        let properties = route.requestProperties
        
        guard let URL = URL(string: properties.path, relativeTo: serviceConfig.apiBaseURL as URL) else {
            fatalError(
                "URL(string: \(properties.path), relativeToURL: \(serviceConfig.apiBaseURL)) == nil"
            )
        }
        
        return TMDBService.session.rx_dataResponse(
            preparedRequest(for: URL, method: properties.method, query: properties.query)
        )
        .flatMap(decodeModel)
    }
}
