//
//  UpcomingMovieCell.swift
//  RxTMDBMovies
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit
import RxSwift
import TMDBApi
import TMDBLibrary
import Kingfisher
import BaseToolbox

/**
    +---------------+
    |               |
    |     image     |
    |               |
    +---------------+
    |     text      |
    +---------------+
 
    prefferred image width: 185.
    image ratio: 16: 9
 */

final class UpcomingMovieCell: UICollectionViewCell {
    
    static let reuseID = "UpcomingMovieCell"
    
    private let imageView = UIImageView()
    private let primaryLabel = UILabel()
    private let secondaryLabel = UILabel()
    private let viewModel: UpcomingMovieCellViewModelProtocol = UpcomingMovieCellViewModel()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.backgroundColor = .systemGray6
        backgroundColor = .clear
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        
        imageView.kf.indicatorType = .activity
        imageView.layer.masksToBounds = true
        imageView.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        primaryLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8).isActive = true
        primaryLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8).isActive = true
        
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 4).isActive = true
        secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor).isActive = true
        secondaryLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor).isActive = true
        secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        primaryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        primaryLabel.textColor = .tmdb_black
        primaryLabel.numberOfLines = 0
        primaryLabel.textAlignment = .center
        
        secondaryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        secondaryLabel.textColor = .tmdb_gray700
        secondaryLabel.numberOfLines = 0
        secondaryLabel.textAlignment = .center
        
        viewModel.outputs.posterPath
            .subscribe { [weak self] in
                self?.imageView.kf.setImage(with: $0)
            }
            .disposed(by: disposeBag)
        viewModel.outputs.title
            .bind(to: primaryLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.outputs.releaseDate
            .bind(to: secondaryLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.borderColor = .separator
        contentView.borderWidth = 1
        contentView.cornerRadius = 10
        shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 10)
        shadowColor = .black.withAlphaComponent(0.1)
        shadowOffset = CGSize(width: 0, height: 2)
        shadowOpacity = 1
        
        imageView.cornerRadius = 10
    }
    
    func populate(movie: Movie) {
        viewModel.inputs.configure(movie: movie)
    }
}
