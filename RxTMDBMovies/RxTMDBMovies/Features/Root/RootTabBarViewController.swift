//
//  RootTabBarViewController.swift
//  RxTMDBMovies
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit
import RxSwift
import TMDBLibrary

final class RootTabBarViewController: UITabBarController {
    
    let viewModel: RootViewModelProtocol = RootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindStyles() {
        view.backgroundColor = .white
    }
    
    override func bindingViewModel() {
        viewModel.outputs.viewControllers
            .map { $0.map { RootTabBarViewController.viewController(from: $0) } }
            .map { $0.map(UINavigationController.init(rootViewController:)) }
            .subscribe { [weak self] in
                self?.setViewControllers($0, animated: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.tabBarItemsData
            .subscribe { [weak self] in
                self?.setTabBarItemStyles($0)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.imagesConfiguration
            .subscribe {
                AppEnvironment.replaceCurrentEnvironment(posterBaseURL: $0.baseURL)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTabBarItemStyles(_ data: TabBarItemsData) {
        for item in data.items {
            switch item {
            case .upcoming(let rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(upcomingTabBarItemStyle)
            case .tv(let rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(tvTabBarItemStyle)
            case .people(let rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(peopleTabBarItemStyle)
            case .profile(let rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(profileTabBarItemStyle)
            }
        }
    }
    
    private func tabBarItem(at atIndex: Int) -> UITabBarItem? {
        if (tabBar.items?.count ?? 0) > atIndex {
            if let item = tabBar.items?[atIndex] {
                return item
            }
        }
        return nil
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
}

extension RootTabBarViewController {
    
    fileprivate static func viewController(from rootViewController: RootViewControllerData) -> UIViewController {
        switch rootViewController {
        case .upcoming:
            return UpcomingMoviesViewController()
        case .tv:
            return UIViewController()
        case .people:
            return UIViewController()
        case .profile:
            return UIViewController()
        }
    }
}


private func upcomingTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "Upcoming"
    tabBarItem.image = UIImage(systemName: "seal")
}

private func tvTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "TV"
    tabBarItem.image = UIImage(systemName: "tv")
}

private func peopleTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "People"
    tabBarItem.image = UIImage(systemName: "star")
}

private func profileTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "Profile"
    tabBarItem.image = UIImage(systemName: "person.fill.viewfinder")
}
