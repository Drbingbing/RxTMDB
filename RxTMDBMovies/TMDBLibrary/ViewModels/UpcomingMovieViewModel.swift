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

struct UpcomingMoviesQuery: Equatable {
    var shouldLoadNextPage: Bool
    var page: Int
}

struct UpcomingMoviesState {
    
    var movies: [Movie] = []
    var shouldLoadNextPage: Bool = true
    var nextPage: Int = 1
    
    static func reduce(state: UpcomingMoviesState, command: UpcomingMovieFetchCommand) -> UpcomingMoviesState {
        switch command {
        case .loadMore:
            var state = state
            state.shouldLoadNextPage = true
            return state
        case .responsed(let moviesResult):
            var state = state
            state.movies.append(contentsOf: moviesResult.results)
            state.shouldLoadNextPage = false
            state.nextPage = moviesResult.page + 1
            return state
        }
    }
}

enum UpcomingMovieFetchCommand {
    case loadMore
    case responsed(MoviesResult)
}

public protocol UpcomingMovieViewModelInputs {
    func viewDidLoad()
    
    /// Call from the controller's `collectionview:willDisplayCell:forItemAt` method.
    ///
    /// - parameter item:       The 0-based index of the item displaying.
    /// - parameter totalItems: The total number of items in the collection view.
    func willDisplayRow(_ item: Int, outOf totalItems: Int)
}

public protocol UpcomingMovieViewModelOutputs {
    var movies: Driver<[Movie]> { get }
    
}

public protocol UpcomingMovieViewModelProtocol {
    var inputs: UpcomingMovieViewModelInputs { get }
    var outputs: UpcomingMovieViewModelOutputs { get }
    
}

public final class UpcomingMovieViewModel: UpcomingMovieViewModelProtocol, UpcomingMovieViewModelInputs, UpcomingMovieViewModelOutputs {
    
    public init() {
        let loadNextPageTrigger = willDisplayItemSubject
          .map { item, total in total > 19 && item >= total - 2 }
          .distinctUntilChanged()
          .filter { $0 }
          .flatMap { _ in Signal<Void>.just(()) }
          .asSignal(onErrorJustReturn: ())
        
        movies = viewDidLoadSubject.flatMap { _ in
            fetchUpcomingMovies(
                loadNextPageTrigger: { state in
                    loadNextPageTrigger
                },
                performSearch: { query in
                    let input = UpcomingMovieInputs(page: query.page)
                    return AppEnvironment.current.apiService.upcomingMovies(input)
                }
            )
        }
        .map(\.movies)
        .asDriver(onErrorJustReturn: [])
    }
    
    public var inputs: UpcomingMovieViewModelInputs { return self }
    public var outputs: UpcomingMovieViewModelOutputs { return self }
    
    // MARK: - Outputs
    
    public let movies: Driver<[Movie]>
    
    
    // MARK: - Inputs
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    private let willDisplayItemSubject = PublishSubject<(item: Int, total: Int)>()
    public func willDisplayRow(_ item: Int, outOf totalItems: Int) {
        willDisplayItemSubject.onNext((item, totalItems))
    }
}

private func fetchUpcomingMovies(
    loadNextPageTrigger: @escaping (Driver<UpcomingMoviesState>) -> Signal<()>,
    performSearch: @escaping (UpcomingMoviesQuery) -> Signal<Result<MoviesResult, ErrorEnvelope>>
) -> Driver<UpcomingMoviesState> {
    let fetchPerformerFeedback: (Driver<UpcomingMoviesState>) -> Signal<UpcomingMovieFetchCommand> = react(
        request: { state in
            UpcomingMoviesQuery(shouldLoadNextPage: state.shouldLoadNextPage, page: state.nextPage)
        },
        effects: { request -> Signal<UpcomingMovieFetchCommand> in
            if !request.shouldLoadNextPage {
                return Signal.empty()
            }
            return performSearch(request)
                .flatMap { result in
                    do {
                        return .just(try result.get())
                    } catch {
                        return .just(.init(results: [], page: request.page))
                    }
                }
                .map(UpcomingMovieFetchCommand.responsed)
        }
    )
    
    let inputFeedbackLoop: (Driver<UpcomingMoviesState>) -> Signal<UpcomingMovieFetchCommand> = { state in
        return loadNextPageTrigger(state).map { s in
            UpcomingMovieFetchCommand.loadMore
        }
    }
    
    return Driver.system(
        initialState: UpcomingMoviesState(),
        reduce: UpcomingMoviesState.reduce,
        feedback: fetchPerformerFeedback, inputFeedbackLoop
    )
}
