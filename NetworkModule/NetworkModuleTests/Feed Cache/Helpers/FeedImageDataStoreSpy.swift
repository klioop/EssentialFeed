//
//  FeedImageDataStoreSpy.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/13.
//

import Foundation
import NetworkModule

class FeedImageDataStoreSpy: FeedImageDataStore {
    private var completions = [(FeedImageDataStore.Result) -> Void]()
    private(set) var receivedMessages = [Message]()
    
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
        completions.append(completion)
        receivedMessages.append(.retrieve(dataFor: url))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        completions[index](.success(data))
    }
    
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
    }
}
