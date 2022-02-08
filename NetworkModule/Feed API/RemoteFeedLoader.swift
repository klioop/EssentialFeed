//
//  RemoteFeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

// extension URLSession, or AF is possible
public protocol HTTPClient {
    // error type should not be RemoteFeedLoader.Error. It comes from the domain in HTTP
    func get(from url: URL, completion: @escaping ((Error?, HTTPURLResponse?) -> Void))
}


public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    // RemoteFeedLoader is mapping a client error to the domain error, in which case is the connectivity
    public func load(completion: @escaping (Error) -> Void ) {
        client.get(from: url) { (error, response) in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.conectivity)
            }            
        }
    }
    
}

