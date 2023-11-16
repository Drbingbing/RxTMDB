//
//  Movie.swift
//  TMDBApi
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation

public struct Movie: Hashable, Decodable {
    
    private let id = UUID()
    
    public let movieID: Int
    public let overview: String
    public let title: String
    public let posterPath: String?
    public let releaseDate: String
    
    public init(movieID: Int, overview: String, title: String, posterPath: String, releaseDate: String) {
        self.movieID = movieID
        self.overview = overview
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case overview, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
