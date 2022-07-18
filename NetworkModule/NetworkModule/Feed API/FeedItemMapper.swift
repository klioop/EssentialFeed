//
//  FeedItemMapper.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/10.
//

import Foundation

public final class FeedItemMapper {
    
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        var images: [FeedImage] {
            items.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
        }
        
        private struct RemoteFeedItem: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard
            response.isOK,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else { throw Error.invalidData }
        
        return root.images
    }
}
