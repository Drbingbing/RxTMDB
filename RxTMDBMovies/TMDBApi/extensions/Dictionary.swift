//
//  Dictionary.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

internal extension Dictionary {
    
    /**
     Merges `self` with `other`, but all values from `other` trump the values in `self`.

     - parameter other: Another dictionary.

     - returns: A merged dictionary.
     */
    func withAllValuesFrom(_ other: Dictionary) -> Dictionary {
      var result = self
      other.forEach { result[$0] = $1 }
      return result
    }
    
    func percentEscaped() -> String {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }.joined(separator: "&")
    }
}
