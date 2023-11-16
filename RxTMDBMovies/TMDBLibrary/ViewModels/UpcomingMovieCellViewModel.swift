//
//  UpcomingMovieCellViewModel.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import TMDBApi
import Foundation
import RxSwift

public protocol UpcomingMovieCellViewModelInputs {
    /// Call to configure with the movie.
    func configure(movie: Movie)
}

public protocol UpcomingMovieCellViewModelOutputs {
    /// Emits the movie image url to be displayed.
    var posterPath: Observable<URL?> { get }
    
    /// Emits the movie title to be displayed.
    var title: Observable<String> { get }
    
    /// Emits the movies release date to be displayed.
    var releaseDate: Observable<String> { get }
}

public protocol UpcomingMovieCellViewModelProtocol {
    var inputs: UpcomingMovieCellViewModelInputs { get }
    var outputs: UpcomingMovieCellViewModelOutputs { get }
}

public final class UpcomingMovieCellViewModel: UpcomingMovieCellViewModelProtocol, UpcomingMovieCellViewModelInputs, UpcomingMovieCellViewModelOutputs {
    
    public init() {
        posterPath = moviewSubject.map(\.posterPath)
            .compactMap { $0 }
            .map { AppEnvironment.current.posterBaseURL + $0 }
            .map { URL(string: $0) }
        title = moviewSubject.map(\.title)
        releaseDate = moviewSubject.map(\.releaseDate)
    }
    
    
    public var inputs: UpcomingMovieCellViewModelInputs { return self }
    public var outputs: UpcomingMovieCellViewModelOutputs { return self }
    
    // MARK: - Outputs
    public let posterPath: Observable<URL?>
    public let title: Observable<String>
    public var releaseDate: Observable<String>
    
    // MARK: - Inputs
    
    private let moviewSubject = PublishSubject<Movie>()
    public func configure(movie: Movie) {
        moviewSubject.onNext(movie)
    }
}
