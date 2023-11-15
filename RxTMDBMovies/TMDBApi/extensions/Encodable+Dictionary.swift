//
//  Encodable+Dictionary.swift
//  TMDBApi
//
//  Created by Bing Bing on 2023/11/15.
//

import Foundation

extension Encodable {
    var dictionaryRepresentation: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}
