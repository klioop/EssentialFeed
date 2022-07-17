//
//  ImageCommentsMapperTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/07/14.
//

import XCTest
import NetworkModule

class ImageCommentsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon2xxHttpResponse() throws {
        let json = makeItemJSON([])
        
        let samples = [199, 150, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: .init(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHttpResponseWithInvalidJson() throws {
        let jsonData = Data("invalid json".utf8)
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(jsonData, from: .init(statusCode: code))
            )
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyJSON = makeItemJSON([])
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyJSON, from: .init(statusCode: code))
            
            XCTAssertEqual(result, [])
        }
    }
    
    func test_map_deliversItemsOn2xxHttpResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02Z"),
            username: "a username")

        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02Z"),
            username: "another username")
        let json = makeItemJSON([item1.json, item2.json])
        
        let samples = [200, 201, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: .init(statusCode: code))
            
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }
    
    // MARK: - Helpers
    
    private func makeItem(
        id: UUID,
        message: String,
        createdAt: (date: Date, isoString: String),
        username: String
    ) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.isoString,
            "author": [
                "username": username
            ]
        ]
        
        return (item, json)
    }
}
