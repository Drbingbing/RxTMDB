//
//  Array+Extension.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import Foundation

extension Array {
    
    public var mid: Element? {
        guard count != 0 else { return nil }
        let midIndex = (count > 1 ? count - 1 : count) / 2
        return self[midIndex]
    }
}
