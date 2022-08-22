//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/17.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    
    public func insert(data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .flatMap(context.save)
            }
        }
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedFeedImage.data(with: url, in: context)
            }
        }
    }
}
