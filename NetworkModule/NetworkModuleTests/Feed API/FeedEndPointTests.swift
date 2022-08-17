//
//  FeedEndPointTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/08/16.
//

import XCTest
import NetworkModule

class FeedEndPointTests: XCTestCase {
    
    func test_feed_endPointURL() {
        let basedURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndPoint.get().url(with: basedURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
    }
    
    func test_feed_endPointURLAfterGivenImage() {
        let image = uniqueImage()
        let basedURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndPoint.get(after: image).url(with: basedURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query?.contains("limit=10"), true, "limit query param")
        XCTAssertEqual(received.query?.contains("after_id=\(image.id)"), true, "after_id param")
    }
}
