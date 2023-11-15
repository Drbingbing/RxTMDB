//
//  UpcomingMovieViewModel.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation
import TMDBApi
import RxSwift

public protocol UpcomingMovieViewModelInputs {
    func viewDidLoad()
}

public protocol UpcomingMovieViewModelOutputs {
    var movies: Observable<[Movie]> { get }
}

public protocol UpcomingMovieViewModelProtocol {
    var inputs: UpcomingMovieViewModelInputs { get }
    var outputs: UpcomingMovieViewModelOutputs { get }
}

public final class UpcomingMovieViewModel: UpcomingMovieViewModelProtocol, UpcomingMovieViewModelInputs, UpcomingMovieViewModelOutputs {
    
    public init() {
        movies = viewDidLoadSubject.map { _ in
            [
                Movie(
                    id: 0,
                    overview: "",
                    title: "Five Nights at Freddy's",
                    posterPath: "https://image.tmdb.org/t/p/w185/qA5kPYZA7FkVvqcEfJRoOy4kpHg.jpg",
                    releaseDate: "2023/11/20"
                ),
                Movie(
                    id: 1,
                    overview: "",
                    title: "Five Nights at Freddy's",
                    posterPath: "https://image.tmdb.org/t/p/w185/qA5kPYZA7FkVvqcEfJRoOy4kpHg.jpg",
                    releaseDate: "2023/11/20"
                )
            ]
        }
    }
    
    public var inputs: UpcomingMovieViewModelInputs { return self }
    public var outputs: UpcomingMovieViewModelOutputs { return self }
    
    // MARK: - Outputs
    
    public let movies: Observable<[Movie]>
    
    
    // MARK: - Inputs
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
}
