//
//  UpcomingMovieLayout.swift
//  RxTMDBMovies
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit
import BaseToolbox

final class UpcomingMovieLayout: UICollectionViewFlowLayout {
    
    var columns: Int = 2
    var prefferedWidth: CGFloat = 182
    var prefferedImageHeight: CGFloat = 278
    
    override func prepare() {
        /// Evaluates if we are gonna finally use the preferred width or not
        
        sectionInset = UIEdgeInsets(20)
        var width = prefferedWidth
        var height = prefferedImageHeight
        
        if let collectionView = collectionView {
            let horizontalInsets = collectionView.adjustedContentInset.left + collectionView.adjustedContentInset.right
            let horizontalSpacePerItem = sectionInset.left + sectionInset.right + horizontalInsets + minimumInteritemSpacing
            let totalHorizontalSpace = horizontalSpacePerItem * CGFloat(columns - 1)
            let maximumItemWidth = ((collectionView.bounds.size.width - totalHorizontalSpace) / CGFloat(columns)).rounded(.down)
            if maximumItemWidth < prefferedWidth {
                width = maximumItemWidth
                height = width * (prefferedImageHeight / prefferedWidth)
            }
        }
        
        itemSize = CGSize(width: width, height: height + 52)
    }
}
