//
//  FeedCachePolicy.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/25.
//

import Foundation

// You can never have an instance of a FeedCachePolicy because it needs no identity and it holds no state
final class FeedCachePolicy {
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        
        return date < maxCacheAge
    }
}

