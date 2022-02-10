//
//  HTTPClient.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/10.
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
