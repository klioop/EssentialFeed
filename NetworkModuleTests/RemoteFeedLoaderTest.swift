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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_sut_load_requestsDataFromURL() {
        let url = URL(string: "https://thisisurl")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
 
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_twice_requestsDataFromURLTwice() {
        let url = URL(string: "https://thisisurl")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
 
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedError: RemoteFeedLoader.Error?
        client.error = NSError(domain: "Test", code: 0)
        
        sut.load { error in capturedError = error }
        
        XCTAssertEqual(capturedError, .conectivity)
    }
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
         }
        
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
