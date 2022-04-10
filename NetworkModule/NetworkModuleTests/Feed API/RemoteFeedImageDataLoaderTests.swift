//
//  RemoteFeedImageDataLoaderTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/10.
//

import XCTest

class RemoteFeedImageDataLoader {
    let client: Any
    
    init(client: Any) {
        self.client = client
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackMemoryLeak(client, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    private class HTTPClientSpy {
        let requestedURLs = [URL]()
    }
}

