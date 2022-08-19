//
//  FeedImageDataStoreSpy.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/13.
//

import Foundation
import NetworkModule

class FeedImageDataStoreSpy: FeedImageDataStore {
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private var insertionCompletion: Result<Void, Error>?
    
    private(set) var receivedMessages = [Message]()
    
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve(dataFor: url))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
    
    func insert(data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionCompletion?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionCompletion = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionCompletion = .success(())
    }
}
