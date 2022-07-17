//
//  RemoteFeedLoadterTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/08.
//

import XCTest
import NetworkModule

class FeedItemMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HttpResponse() throws {
        let json = makeItemJSON([])
        
        let samples = [199, 201, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HttpResponseWithInvalidJson() {
        let jsonData = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemMapper.map(jsonData, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyJSON = makeItemJSON([])
                
        let result = try FeedItemMapper.map(emptyJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HttpResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string:"https://a-url.com")!
        )
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string:"https://b-url.com")!
        )
        let json = makeItemJSON([item1.json, item2.json])
        
        let result = try FeedItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func makeItem(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        imageURL: URL
    ) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let json: [String: Any] = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}
