//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/12.
//

import XCTest

class FeedViewController {
    let loader: FeedViewControllerTests.FeedLoaderSpy
    
    init(loader: FeedViewControllerTests.FeedLoaderSpy) {
        self.loader = loader
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = FeedLoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    class FeedLoaderSpy {
        var loadCallCount = 0
    }
}
