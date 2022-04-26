//
//  FeedCache.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/26.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
