//
//  Optional+Extension.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import Foundation

extension Optional {
    
    public func ifLet(_ projected: (Wrapped) -> Void) {
        if case let .some(wrapped) = self {
            projected(wrapped)
        }
    }
}
