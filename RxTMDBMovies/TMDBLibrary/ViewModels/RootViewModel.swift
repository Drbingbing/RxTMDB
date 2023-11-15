//
//  RootViewModel.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation
import RxSwift
import RxCocoa
import TMDBApi

public typealias RootViewControllerIndex = Int

public enum RootViewControllerData {
    case upcoming
    case tv
    case people
    case profile
}

public enum TabBarItem {
    case upcoming(RootViewControllerIndex)
    case tv(RootViewControllerIndex)
    case people(RootViewControllerIndex)
    case profile(RootViewControllerIndex)
}

public struct TabBarItemsData {
    
    public let items: [TabBarItem]
    
    public init(items: [TabBarItem]) {
        self.items = items
    }
}

public protocol RootViewModelInputs {
    func viewDidLoad()
}

public protocol RootViewModelOutputs {
    var viewControllers: Observable<[RootViewControllerData]> { get }
    var tabBarItemsData: Observable<TabBarItemsData> { get }
    var imagesConfiguration: Observable<ImagesConfiguration> { get }
}

public protocol RootViewModelProtocol {
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
}

public final class RootViewModel: RootViewModelProtocol, RootViewModelInputs, RootViewModelOutputs {
    
    public init() {
        viewControllers = viewDidLoadSubject.map { _ in generateStandardViewControllers() }
        
        tabBarItemsData = viewDidLoadSubject.map { _ in tabData() }
        
        imagesConfiguration = viewDidLoadSubject
            .flatMap {
                AppEnvironment.current.apiService.configuration()
            }
            .map { try $0.get() }
            .asObservable()
    }
    
    public let viewControllers: Observable<[RootViewControllerData]>
    public let tabBarItemsData: Observable<TabBarItemsData>
    public var imagesConfiguration: Observable<ImagesConfiguration>
    
    public var inputs: RootViewModelInputs { return self }
    public var outputs: RootViewModelOutputs { return self }
    
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
}


private func generateStandardViewControllers() -> [RootViewControllerData] {
    return [.upcoming, .tv, .people, .profile]
}

private func tabData() -> TabBarItemsData {
    let items: [TabBarItem] = [
        .upcoming(0),
        .tv(1),
        .people(2),
        .profile(3)
    ]
    
    return TabBarItemsData(items: items)
}
