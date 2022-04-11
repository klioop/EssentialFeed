//
//  LocalFeedImageDataLoaderTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/11.
//

import XCTest

class LocalFeedImageDataLoader {
    init(store: Any) {
        
    }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessagesStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpy {
        let receivedMessages = [Any]()
    }
}

