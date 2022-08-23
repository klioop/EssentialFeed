//
//  Combine+FeedImageDataLoader.swift
//  EssentialApp
//
//  Created by klioop on 2022/08/23.
//

import Foundation
import Combine
import NetworkModule

public extension FeedImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImageDataPublisher(from url: URL) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.loadImageData(from: url) })
            }
        }
        .eraseToAnyPublisher()
    }
}
