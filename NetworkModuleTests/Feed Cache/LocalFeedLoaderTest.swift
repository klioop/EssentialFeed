//
//  LocalFeedLoaderTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/19.
//

import Foundation
import XCTest
import NetworkModule

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deletedCacheFeed()
    }
}

class FeedStore {
    var deletionCallCount = 0
    
    func deletedCacheFeed() {
        deletionCallCount += 1
    }
}

class LocalFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deletionCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        let items = [uniuqeItem(), uniuqeItem()]
        sut.save(items)
        
        XCTAssertEqual(store.deletionCallCount, 1)
    }
    
    private func uniuqeItem() -> FeedItem {
        return FeedItem(id: .init(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-given-url.com")!
    }
}
