//
//  ServiceTest.swift
//  TMDBApiTests
//
//  Created by 鍾秉辰 on 2023/11/15.
//

import XCTest
import RxSwift
@testable import TMDBApi

final class ServiceTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    let service = TMDBService()
        
    func testAPI() {
        service.configuration()
            .asObservable()
            .subscribe { result in
                print(result)
            }
            .disposed(by: disposeBag)
    }
}
