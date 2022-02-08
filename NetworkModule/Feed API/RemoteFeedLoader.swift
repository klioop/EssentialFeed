//
//  RemoteFeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

// URLSession, AF etc
public protocol HTTPClient {
    func get(from url: URL)
}


public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
    
}

