//
//  ServiceDecodeHelpers.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import RxCocoa

extension TMDBService {
    
    func decodeModel<T: Decodable>(_ jsonData: Result<Data, ErrorEnvelope>) -> Signal<Result<T, ErrorEnvelope>> {
        return Signal.just(jsonData)
            .flatMap {
                switch $0 {
                case let .success(data):
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        return .just(Result<T, ErrorEnvelope>.success(decodedObject))
                    } catch {
                        return .just(Result<T, ErrorEnvelope>.failure(.couldNotDecodeJSON(error)))
                    }
                case let .failure(error):
                    return .just(Result<T, ErrorEnvelope>.failure(error))
                }
            }
    }
}
