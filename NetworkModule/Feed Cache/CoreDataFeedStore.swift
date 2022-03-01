//
//  CoreDataFeedStore.swift
//  NetworkModule
//
//  Created by klioop on 2022/03/01.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
    public init() {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func deletedCacheFeed(completion: @escaping DeletionCompletion) {
        
    }
}
