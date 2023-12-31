//
//  NSURLSession.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import RxCocoa

private func parseJSONData(_ data: Data) -> Any? {
    return (try? JSONSerialization.jsonObject(with: data, options: []))
}

internal extension URLSession {
    
    private func isValidResponse(response: HTTPURLResponse) -> Bool {
        guard (200..<300).contains(response.statusCode),
              let headers = response.allHeaderFields as? [String: String],
              let contentType = headers["Content-Type"], contentType.hasPrefix("application/json") else {
            return false
        }
        
        return true
    }
    
    /// Wrap an URLSession producer with error envelope logic.
    func rx_dataResponse(_ request: URLRequest) -> Signal<Result<Data, ErrorEnvelope>> {
        let producer = self.rx.response(request: request)
        
        print("⚪️ [TMDBApi] Starting request.")
        return producer
            .flatMap { response, data in
                guard self.isValidResponse(response: response) else {
                    if let json = parseJSONData(data) as? [String: Any] {
                        let envelope = ErrorEnvelope.parse(from: json)
                        print("[TMDBApi] Failure: \(envelope)")
                        return Signal.just(Result<Data, ErrorEnvelope>.failure(envelope))
                    } else {
                        let envelope = ErrorEnvelope.couldNotParseJSON
                        print("[TMDBApi] Failure: \(envelope)")
                        return Signal.just(Result<Data, ErrorEnvelope>.failure(envelope))
                    }
                }
                
                print("🔵 [TMDBApi] Success")
                
                return Signal.just(Result<Data, ErrorEnvelope>.success(data))
            }
            .asSignal { error in
                Signal.just(.failure(.couldNotParseJSON))
            }
    }
}
