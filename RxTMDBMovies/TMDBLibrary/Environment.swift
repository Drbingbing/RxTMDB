//
//  Environment.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation
import TMDBApi

public struct Environment {
    
    /// A type that exposes endpoint for fetching TMDB movies.
    public let apiService: TMDBServiceProtocol
    
    public let imagesConfiguration: ImagesConfiguration
    
    init(
        apiService: TMDBServiceProtocol = TMDBService(),
        imagesConfiguration: ImagesConfiguration
    ) {
        self.apiService = apiService
        self.imagesConfiguration = imagesConfiguration
    }
}
