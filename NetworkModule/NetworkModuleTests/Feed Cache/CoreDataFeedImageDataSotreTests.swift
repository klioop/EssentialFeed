//
//  CoreDataFeedImageDataSotreTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/14.
//

import XCTest
import NetworkModule

class CoreDataFeedImageDataStore: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: notFound())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "https://a-url.com")!
        let anotherURL = URL(string: "https://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteWith: notFound(), for: anotherURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let storedData = Data("a stored data".utf8)
        let matchingURL = URL(string: "https://a-url.com")!
        
        insert(storedData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteWith: found(storedData), for: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = URL(string: "https://a-url.com")!
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)
        
        expect(sut, toCompleteWith: found(lastStoredData), for: url)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataFeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func localImage(url: URL) -> LocalFeedImage {
        LocalFeedImage(id: .init(), description: "any", location: "any", url: url)
    }
    
    private func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }
    
    private func notFound() -> Result<Data?, Error> {
        .success(.none)
    }
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for insertion completion")
        let image = localImage(url: url)
        
        sut.insert([image], timestamp: Date()) { result in
            if case let .failure(error) = result {
                XCTFail("Failed to save \(image) with error \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        do {
            try sut.insert(data: data, for: url)
        } catch {
            XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: CoreDataFeedStore, toCompleteWith expectedResult: Result<Data?, Error>, for url: URL = anyURL(), file: StaticString = #filePath, line: UInt = #line) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
