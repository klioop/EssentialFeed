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
    let currentDate: () -> Date
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem]) {
        store.deletedCacheFeed() { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate())
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    var deletionCallCount = 0
    var insertions = [(items: [FeedItem], timestamp: Date)]()
    var deletionCompletions = [DeletionCompletion]()
    
    func deletedCacheFeed(completion: @escaping DeletionCompletion) {
        deletionCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func insert(_ items: [FeedItem], timestamp: Date) {
        insertions.append((items, timestamp))
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
        
        XCTAssertEqual(store.insertions.count, 0)
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let items = [uniuqeItem(), uniuqeItem()]
        let (sut, store) =  makeSUT()
        
        sut.save(items)
        store.completeInsertionSuccessfully()
        
        XCTAssertEqual(store.insertions.count, 1)
    }
    
    func test_save_requestsNewCacheInsertionOnWithTimestampSuccessfulDeletion() {
        let items = [uniuqeItem(), uniuqeItem()]
        let timestamp = Date()
        let (sut, store) =  makeSUT(currentDate: { timestamp })
        
        sut.save(items)
        store.completeInsertionSuccessfully()
        
        XCTAssertEqual(store.insertions.first?.items, items)
        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
    }
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
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
