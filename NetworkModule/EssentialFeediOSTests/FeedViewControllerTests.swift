//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/12.
//

import XCTest
import UIKit

class FeedViewController: UIViewController {
    var loader: FeedViewControllerTests.FeedLoaderSpy?
    
    convenience init(loader: FeedViewControllerTests.FeedLoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = FeedLoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = FeedLoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    class FeedLoaderSpy {
        private(set) var loadCallCount = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
