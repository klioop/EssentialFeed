//
//  Combine+LocalFeedLoader.swift
//  EssentialApp
//
//  Created by klioop on 2022/08/23.
//

import Foundation
import Combine
import NetworkModule

public extension LocalFeedLoader {
    typealias Publisher = AnyPublisher<[FeedImage], Error>
    
    func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
        Deferred {
            Future(self.load)
        }
        .eraseToAnyPublisher()
    }
}
