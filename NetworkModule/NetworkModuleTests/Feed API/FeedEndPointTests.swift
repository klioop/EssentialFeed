//
//  FeedEndPointTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/08/16.
//

import XCTest
import NetworkModule

class FeedEndPointTests: XCTestCase {
    
    func test_feedEndPoint() {
        let basedURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndPoint.get.url(with: basedURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
    }
}
