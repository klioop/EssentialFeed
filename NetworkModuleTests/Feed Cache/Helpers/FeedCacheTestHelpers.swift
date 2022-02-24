//
//  FeedCacheTestsHelpers.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/24.
//

import Foundation
import NetworkModule





func uniuqeImage() -> FeedImage {
    return FeedImage(id: .init(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniuqeImage(), uniuqeImage()]
    let localItems = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    
    return (models, localItems)
}

extension Date {
    
    func adding(days: Int) -> Date {
        return Calendar.init(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
