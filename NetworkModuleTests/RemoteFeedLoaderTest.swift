//
//  RemoteFeedLoadterTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/08.
//

import Foundation
import XCTest

class RemoteFeedLoader {
    
    func load() {
        HTTPClient.shared.get(from: URL(string: "a-given-url.com")!)
    }
    
}

class HTTPClient {
    
    static var shared: HTTPClient = HTTPClient()
    
    private init() {}
    
    var requestedUrl: URL?
    
    func get(from url: URL) {
        requestedUrl = url
    }
}

class HTTPClientSpy: HTTPClient {
    
    override func get(from url: URL) {
        requestedUrl = url
    }
    
}

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_doesnotUrlRequest() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedUrl)
    }

    func test_sut_load() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedUrl)
    }
}
