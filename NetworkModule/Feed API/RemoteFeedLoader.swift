//
//  RemoteFeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

// URLSession, AF etc
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping ((Error) -> Void))
}


public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    // RemoteFeedLoader is mapping a client error to the domain error, in which case is the connectivity
    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.conectivity)
        }
    }
    
}

