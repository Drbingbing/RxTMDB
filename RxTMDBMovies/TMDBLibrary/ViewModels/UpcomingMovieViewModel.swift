//
//  UpcomingMovieViewModel.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation
import TMDBApi
import RxSwift
import RxCocoa
import RxFeedback

struct UpcomingMoviesState {
    
    var movies: [Movie]
    var input: UpcomingMovieInputs
    
    init(input: UpcomingMovieInputs) {
        self.input = input
        self.movies = []
    }
    
    static func reduce(state: UpcomingMoviesState, command: UpcomingMovieFetchCommand) -> UpcomingMoviesState {
        switch command {
        case .loadMore:
            return state
        case .responsed(let moviesResult):
            var newState = state
            newState.movies.append(contentsOf: moviesResult.results)
            return newState
        }
    }
}

enum UpcomingMovieFetchCommand {
    case loadMore
    case responsed(MoviesResult)
}

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
            fetchUpcomingMovies(input: <#T##Signal<UpcomingMovieInputs>#>, loadNextPageTrigger: <#T##(Driver<UpcomingMoviesState>) -> Signal<()>#>, performSearch: <#T##(UpcomingMovieInputs) -> Signal<Result<MoviesResult, ErrorEnvelope>>#>)
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

private func fetchUpcomingMovies(
    input: Signal<UpcomingMovieInputs>,
    loadNextPageTrigger: @escaping (Driver<UpcomingMoviesState>) -> Signal<()>,
    performSearch: @escaping (UpcomingMovieInputs) -> Signal<Result<MoviesResult, ErrorEnvelope>>
) -> Driver<UpcomingMoviesState> {
    let fetchPerformerFeedback: (Driver<UpcomingMoviesState>) -> Signal<UpcomingMovieFetchCommand> = react(
        request: { state in
            UpcomingMovieInputs(page: state.input.page)
        },
        effects: { request -> Signal<UpcomingMovieFetchCommand> in
            return performSearch(request)
                .compactMap { try? $0.get() }
                .map(UpcomingMovieFetchCommand.responsed)
        }
    )
    
    let inputFeedbackLoop: (Driver<UpcomingMoviesState>) -> Signal<UpcomingMovieFetchCommand> = { state in
        return loadNextPageTrigger(state).map { s in
            UpcomingMovieFetchCommand.loadMore
        }
    }
    
    return Driver.system(
        initialState: UpcomingMoviesState(input: UpcomingMovieInputs(page: 1)),
        reduce: UpcomingMoviesState.reduce,
        feedback: fetchPerformerFeedback, inputFeedbackLoop
    )
}
