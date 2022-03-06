//
//  NetworkModuleCacheIntegrationTests.swift
//  NetworkModuleCacheIntegrationTests
//
//  Created by klioop on 2022/03/06.
//

import XCTest
import NetworkModule

class NetworkModuleCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        let saveExp = expectation(description: "Wait for save completion")
        sutToPerformSave.save(feed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: feed)
    }
    
    func test_save_overridesItemsSavedOnASeparteInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueImageFeed().models
        let lastFeed = uniqueImageFeed().models
        
        let saveExp1 = expectation(description: "Wait for save completion")
        sutToPerformFirstSave.save(firstFeed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            saveExp1.fulfill()
        }
        wait(for: [saveExp1], timeout: 1.0)
        
        let saveExp2 = expectation(description: "Wait for save completion")
        sutToPerformLastSave.save(lastFeed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            saveExp2.fulfill()
        }
        wait(for: [saveExp2], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: lastFeed)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle )
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        let loadExp = expectation(description: "Wait for load completion")
        sut.load { loadResult in
            switch (loadResult) {
            case let .success(feedImage):
                XCTAssertEqual(feedImage, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
            }
            loadExp.fulfill()
        }
        wait(for: [loadExp], timeout: 1.0)
    }
    
    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
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
    
}
