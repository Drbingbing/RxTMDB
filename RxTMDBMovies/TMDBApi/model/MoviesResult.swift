//
//  MoviesResult.swift
//  TMDBApi
//
//  Created by Bing Bing on 2023/11/15.
//

import Foundation

public struct MoviesResult: Decodable {
    
    public let results: [Movie]
    public let page: Int
    
    public init(results: [Movie], page: Int) {
        self.results = results
        self.page = page
    }
    
}
