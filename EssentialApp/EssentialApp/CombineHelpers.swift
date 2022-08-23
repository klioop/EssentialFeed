//
//  CombineHelpers.swift
//  EssentialApp
//
//  Created by klioop on 2022/07/11.
//

import os
import UIKit
import Combine
import NetworkModule

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        // catch operator is equivalent to the `FeedLoaderWithFallbackComposite`
        // self is a primary loader
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher {
    func logCacheMiss(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveCompletion: { result in
            if case .failure = result {
                logger.trace("Cache miss for url: \(url)")
            }
        })
        .eraseToAnyPublisher()
    }
    
    func logErrors(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveCompletion: { result in
            if case let .failure(error) = result {
                logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
            }
        })
        .eraseToAnyPublisher()
    }
    
    func logElapsed(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        var startTime = CACurrentMediaTime()
        
        return handleEvents(receiveSubscription: { _ in
            startTime = CACurrentMediaTime()
            logger.trace("Started loading url: \(url)")
        },
                            receiveCompletion: { _ in
            let elapsed = CACurrentMediaTime() - startTime
            logger.trace("Finished loading url: \(url), in \(elapsed)")
        })
        .eraseToAnyPublisher()
    }
}
