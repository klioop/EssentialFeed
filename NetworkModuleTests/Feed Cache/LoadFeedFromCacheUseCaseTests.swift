//
//  LoadFeedFromCacheUseCaseTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/22.
//

import XCTest
import NetworkModule

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) =  makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackMemoryLeak(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
        
        enum ReceivedMessages: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        
        private(set) var receivedMessages = [ReceivedMessages]()
        
        var deletionCompletions = [DeletionCompletion]()
        var insertionCompletions = [InsertionCompletion]()
        
        func deletedCacheFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedFeed)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(feed, timestamp))
        }
        
        func completeDeletion(with error: Error, at index: Int = 0)  {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func completeInsertion(with error: Error, at index: Int = 0)  {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
}

