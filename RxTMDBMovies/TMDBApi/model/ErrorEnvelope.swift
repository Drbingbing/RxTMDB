//
//  ErrorEnvelope.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

public struct ErrorEnvelope {
    public let errorMessages: [String]
    public let tmdbCode: TMDBCode?
    public let httpCode: Int
    
    public init(errorMessages: [String] = [], tmdbCode: TMDBCode? = .APIError, httpCode: Int = 400) {
        self.errorMessages = errorMessages
        self.tmdbCode = tmdbCode
        self.httpCode = httpCode
    }
    
    public enum TMDBCode: String {
        case JSONParsingFailed = "json_parsing_failed"
        case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
        case APIError = "api_error"
        case DecodingJSONFailed = "decoding_json_failed"
    }
}

extension ErrorEnvelope: Error {}

extension ErrorEnvelope {
    
    /// A general error that some JSON could not be decoded.
    ///
    /// - parameter decodeError: The JSONDecoder decoding error.
    ///
    /// - returns: An error envelope that describes why decoding failed.
    internal static func couldNotDecodeJSON(_ decodeError: Error) -> ErrorEnvelope {
        return ErrorEnvelope(
            errorMessages: [decodeError.localizedDescription],
            tmdbCode: .DecodingJSONFailed,
            httpCode: 400
        )
    }
    
    /// A general error that JSON could not be parsed.
    internal static let couldNotParseJSON = ErrorEnvelope(
        errorMessages: [],
        tmdbCode: .JSONParsingFailed,
        httpCode: 400
    )
    
    internal static func tmdbAPIError(_ message: String) -> ErrorEnvelope {
        return ErrorEnvelope(
            errorMessages: [message],
            tmdbCode: .APIError,
            httpCode: 200
        )
    }
}

extension ErrorEnvelope {
    
    static func parse(from jsonData: [String: Any]) -> ErrorEnvelope {
        let errorMessage = jsonData["status_message"] as? String ?? ""
        let statusCode = jsonData["status_code"] as? Int ?? 400
        return ErrorEnvelope(errorMessages: [errorMessage], tmdbCode: .APIError, httpCode: statusCode)
    }
}
