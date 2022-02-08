//
//  RemoteFeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// extension URLSession, or AF is possible
public protocol HTTPClient {
    // error type should not be RemoteFeedLoader.Error. It comes from the domain in HTTP
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    // RemoteFeedLoader is mapping a client error to the domain error, in which case is the connectivity
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { (result) in
            switch result {
            case let .success(data, _):
                if let json = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(json.items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.conectivity))
            }
        }
    }
    
}

struct Root: Decodable {
    let items: [FeedItem]
}
