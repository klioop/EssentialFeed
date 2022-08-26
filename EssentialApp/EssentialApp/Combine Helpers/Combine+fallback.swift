//
//  Combine+fallback.swift
//  EssentialApp
//
//  Created by klioop on 2022/08/23.
//

import Foundation
import Combine

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        // catch operator is equivalent to the `FeedLoaderWithFallbackComposite`
        // self is a primary loader
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}
