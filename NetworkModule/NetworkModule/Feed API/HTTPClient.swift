//
//  HTTPClient.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/10.
//

import Foundation

// extension URLSession, or AF is possible
public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    // error type should not be RemoteFeedLoader.Error. It comes from the domain in HTTP
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
