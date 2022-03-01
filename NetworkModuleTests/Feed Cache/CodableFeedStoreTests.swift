//
//  CodableFeedStoreTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/26.
//

import XCTest
import NetworkModule

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCahce()

    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedValues()

    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()

    func test_sideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpecs {
    func test_retrieve_failsOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpects {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionerror()
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCahce() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_failsOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "Invalid Data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "Invalid Data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let latestInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(latestInsertionError)
    }
    
    func test_insert_overridesPreviouslyInsertedValues() {
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }
    
    func test_delete_hasNoSideEffectsOnDeletionerror() {
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperatoinsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "operation1")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completedOperatoinsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "operation2")
        sut.deletedCacheFeed { _ in
            completedOperatoinsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "operation3")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completedOperatoinsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperatoinsInOrder, [op1, op2, op3], "Expected side-effects to run serailly but operations finished in the wrong order")
    }
    
    
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackMemoryLeak(sut, file: file, line: line)
        
        return sut
    }
    
    @discardableResult
    private func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for deledtedCacheFeed completion")
        
        var receivedError: Error?
        sut.deletedCacheFeed { error in
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for insert completion")
        
        var receivedError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { insertionError in
            receivedError = insertionError
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { retrievedResult in
            switch (retrievedResult, expectedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(retrieved), .found(expected)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult)
        expect(sut, toRetrieve: expectedResult)
    }
    
    private func setupEmptyStoreState() {
        deleteArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteArtifacts()
    }
    
    private func deleteArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func noDeletePermissionURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
    
}
