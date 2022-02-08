//
//  RemoteFeedLoadterTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/08.
//

import Foundation
import XCTest

// url is the detail of the implementation of RemoteFeedLoader. It should not be in the public interface
class RemoteFeedLoader {
    
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
    
}

// URLSession, AF etc
protocol HTTPClient {
    func get(from url: URL)
}


class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedUrl)
    }

    func test_sut_load_requestDataFromURL() {
        let url = URL(string: "https://thisisurl")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
 
        XCTAssertEqual(client.requestedUrl, url)
    }
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedUrl: URL?
        
        func get(from url: URL) {
            requestedUrl = url
         }
        
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
