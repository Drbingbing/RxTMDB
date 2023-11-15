//
//  UpcomingMovieInputs.swift
//  TMDBApi
//
//  Created by Bing Bing on 2023/11/15.
//

import Foundation

public struct UpcomingMovieInputs: Encodable, Equatable {
    
    public let page: Int
    
    public init(page: Int) {
        self.page = page
    }
}
