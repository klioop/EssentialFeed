//
//  RemoteFeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader {
    
    // url is the detail of the implementation of RemoteFeedLoader. It should not be in the public interface
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    // RemoteFeedLoader is mapping a client error to the domain error which is the connectivity
    public func load(completion: @escaping (LoadFeedResult) -> Void) {
        client.get(from: url) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.conectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let feedItems = try FeedItemMapper.map(data, from: response)
            return .success(feedItems.toModels())
        } catch {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    
    func toModels() -> [FeedItem] {
        return map { FeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.image) }
    }
}



