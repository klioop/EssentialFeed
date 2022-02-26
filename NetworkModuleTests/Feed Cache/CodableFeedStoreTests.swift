//
//  CodableFeedStoreTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/26.
//

import XCTest
import NetworkModule

class CodableFeedStore {
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { result in
            switch result {
            case .empty: break
            default:
                XCTFail("Expected empty got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
