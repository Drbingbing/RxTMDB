//
//  Movie.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation

public struct Movie: Hashable {
    
    public let id: Int
    public let overview: String
    public let title: String
    public let posterPath: String
    public let releaseDate: String
    
    public init(id: Int, overview: String, title: String, posterPath: String, releaseDate: String) {
        self.id = id
        self.overview = overview
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
