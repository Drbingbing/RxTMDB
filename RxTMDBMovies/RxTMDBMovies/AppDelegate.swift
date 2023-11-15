//
//  AppDelegate.swift
//  RxTMDBMovies
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit
import TMDBLibrary
import TMDBApi
import RxSwift

private let BearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhYjA2YTk1NjNmYWU3NDMwOTc2ZWYxYzg3NjQ3OTMxMyIsInN1YiI6IjYyYmFjYjI4MTJhYWJjMDYxYjYyNjg4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vLIgZtntgNbfv79SmwSG1tLmS4vrk7lvbqMLsKVvF_U"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIViewController.doBadSwizzleStuff()
        
        /// eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhYjA2YTk1NjNmYWU3NDMwOTc2ZWYxYzg3NjQ3OTMxMyIsInN1YiI6IjYyYmFjYjI4MTJhYWJjMDYxYjYyNjg4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vLIgZtntgNbfv79SmwSG1tLmS4vrk7lvbqMLsKVvF_U
        AppEnvironment.login(AccessTokenEnvelope(token: BearerToken))
        AppEnvironment.current.apiService
            .configuration()
            .asObservable()
            .subscribe { result in
                if case let .success(config) = result {
                    let posterSize = config.posterSizes.filter { $0 != "original" }.mid ?? "w185"
                    AppEnvironment.replaceCurrentEnvironment(posterBaseURL: config.baseURL + posterSize)
                }
                print(AppEnvironment.current.posterBaseURL)
            }
            .disposed(by: disposeBag)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

