//
//  UpcomingMoviesViewController.swift
//  RxTMDBMovies
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit
import RxSwift
import TMDBApi
import TMDBLibrary

final class UpcomingMoviesViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private let viewModel: UpcomingMovieViewModelProtocol = UpcomingMovieViewModel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let disposeBag = DisposeBag()
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: Movie) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCell.reuseID, for: indexPath) as! UpcomingMovieCell
        cell.populate(movie: item)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func bindingUI() {
        view.addSubview(collectionView)
        collectionView.register(UpcomingMovieCell.self, forCellWithReuseIdentifier: UpcomingMovieCell.reuseID)
        collectionView.dataSource = dataSource
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        
        navigationItem.title = "Upcoming Movies"
    }
    
    override func bindStyles() {
        view.backgroundColor = .systemGray6
        collectionView.backgroundColor = .clear
    }
    
    override func bindingViewModel() {
        viewModel.outputs.movies
            .subscribe { [weak self] in
                guard let self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
                snapshot.appendSections([.main])
                snapshot.appendItems($0, toSection: .main)
                self.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, 
            subitems: [item]
        )
        group.interItemSpacing = .flexible(8)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension UpcomingMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity.scaledBy(0.96)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }
}
