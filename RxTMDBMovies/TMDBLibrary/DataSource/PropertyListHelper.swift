//
//  PropertyListHelper.swift
//  TMDBLibrary
//
//  Created by Bing Bing on 2023/11/15.
//

import Foundation

public struct PropertyListHelper {
    
    public static func decode<T: Decodable>(resourceName: String = "Info") -> T {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: ".plist") else {
            fatalError("Unable to decode resourceName: \(resourceName)")
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try PropertyListDecoder().decode(T.self, from: data)
        } catch {
            fatalError("fail to decode property list.")
        }
    }
}
