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
        store.deletedCacheFeed() { [unowned self] error in
            if error == nil {
                self.store.insert(items)
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    var deletionCallCount = 0
    var insertionCallCount = 0
    var deletionCompletions = [DeletionCompletion]()
    
    func deletedCacheFeed(completion: @escaping DeletionCompletion) {
        deletionCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func insert(_ items: [FeedItem]) {
        insertionCallCount += 1
    }
    
    func completeDeletionSuccessfully(with error: Error, at index: Int = 0)  {
        deletionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    
}

class LocalFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) =  makeSUT()
        
        XCTAssertEqual(store.deletionCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) =  makeSUT()
        
        let items = [uniuqeItem(), uniuqeItem()]
        sut.save(items)
        
        XCTAssertEqual(store.deletionCallCount, 1)
    }
    
    func test_save_failsOnCacheDeletion() {
        let items = [uniuqeItem(), uniuqeItem()]
        let (sut, store) =  makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletionSuccessfully(with: deletionError)
        
        XCTAssertEqual(store.insertionCallCount, 0)
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let items = [uniuqeItem(), uniuqeItem()]
        let (sut, store) =  makeSUT()
        
        sut.save(items)
        store.completeInsertionSuccessfully()
        
        XCTAssertEqual(store.insertionCallCount, 1)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeak(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniuqeItem() -> FeedItem {
        return FeedItem(id: .init(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-given-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
