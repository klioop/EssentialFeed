//
//  RemoteFeedLoadterTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/08.
//

import Foundation
import XCTest
import NetworkModule

// url is the detail of the implementation of RemoteFeedLoader. It should not be in the public interface


class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedUrl)
    }

    func test_sut_load_requestsDataFromURL() {
        let url = URL(string: "https://thisisurl")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
 
        XCTAssertEqual(client.requestedUrl, url)
    }
    
    func test_load_twice_requestsDataFromURLTwice() {
        let url = URL(string: "https://thisisurl")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
 
        XCTAssertEqual(client.requestedUrl, url)
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedUrl: URL?
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedUrl = url
            requestedURLs.append(url)
         }
        
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
