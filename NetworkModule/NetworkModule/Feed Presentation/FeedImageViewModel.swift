//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public init(description: String?, location: String?) {
        self.description = description
        self.location = location
    }
    
    public var hasLocation: Bool {
        location != nil
    }
}
