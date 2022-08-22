//
//  FeedImageDataStore.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/12.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
