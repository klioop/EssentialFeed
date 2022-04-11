//
//  LocalFeedImageDataLoaderTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/11.
//

import XCTest
import NetworkModule

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

final class LocalFeedImageDataLoader: FeedImageDataLoader {
    
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    private let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url)
        return Task()
    }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessagesStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoreDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy: FeedImageDataStore {
        private(set) var receivedMessages = [Message]()
        
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}

