//
//  FeedImageDataStore.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/12.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}
