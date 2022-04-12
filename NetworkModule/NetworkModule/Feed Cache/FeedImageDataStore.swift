//
//  FeedImageDataStore.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/12.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
