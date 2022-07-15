//
//  RemoteLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/07/15.
//

import Foundation

public final class RemoteLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.conectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let feedItems = try FeedItemMapper.map(data, from: response)
            return .success(feedItems)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
