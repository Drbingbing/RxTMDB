//
//  TMDBServiceProtocol.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import RxCocoa

public protocol TMDBServiceProtocol {
    var serviceConfig: ServiceConfigProtocol { get }
    var oauthToken: OauthTokenAuthProtocol? { get }
    
    init(serviceConfig: ServiceConfigProtocol, oauthToken: OauthTokenAuthProtocol?)
    
    func login(_ oauthToken: OauthTokenAuthProtocol) -> Self
    
    /// Images congigurations
    func configuration() -> Signal<Result<ImagesConfiguration, ErrorEnvelope>>
    
    /// Get a list of movies that are being released soon.
    func upcomingMovies(_ inputs: UpcomingMovieInputs) -> Signal<Result<MoviesResult, ErrorEnvelope>>
}

extension TMDBServiceProtocol {
    
    ///Prepares a request to be sent to the server.
    ///
    /// - parameter URL:    The URL to turn into a request and prepare.
    /// - parameter method: The HTTP verb to use for the request.
    /// - parameter query:  Additional query params that should be attached to the request.
    ///
    /// - returns: A new URL request that is properly configured for the server.
    public func preparedRequest(for url: URL, method: Method = .GET, query: [String: Any] = [:]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return preparedRequest(forRequest: request, query: query)
    }
    
    /// Prepares a URL request to be sent to the server.
    ///
    /// - parameter originalRequest: The request that should be prepared.
    /// - parameter queryString:     The GraphQL query string for the request.
    ///
    /// - returns: A new URL request that is properly configured for the server.
    public func preparedRequest(forRequest originalRequest: URLRequest, query: [String: Any] = [:]) -> URLRequest {
        var request = originalRequest
        
        guard let URL = request.url else {
            return request
        }
        
        var headers = defaultHeaders
        
        let method = request.httpMethod?.uppercased()
        var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems ?? []
        queryItems.append(contentsOf: defaultQueryParams.map(URLQueryItem.init(name:value:)))
        
        if method == .some("POST") || method == .some("PUT") {
          if request.httpBody == nil {
            headers["Content-Type"] = "application/json; charset=utf-8"
            request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
          }
        }
        
        components.queryItems = queryItems.sorted { $0.name < $1.name }
        
        request.url = components.url
        request.httpBody = query.percentEscaped().data(using: .utf8)
        
        let currentHeaders = request.allHTTPHeaderFields ?? [:]
        request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)
        
        return request
    }
    
    internal var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        
        headers["accept"] = "application/json"
        headers["Authorization"] = authrizationHeader
        
        return headers
    }
    
    fileprivate var authrizationHeader: String? {
        if let token = oauthToken?.token {
            return "Bearer \(token)"
        }
        return ""
    }
    
    fileprivate var defaultQueryParams: [String: String] {
        var query: [String: String] = [:]
        query["language"] = "en-US"
        return query
    }
}
