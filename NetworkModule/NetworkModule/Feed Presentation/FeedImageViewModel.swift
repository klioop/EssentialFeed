//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let isLoading: Bool
    public let shouldRetry: Bool
    public let image: Image?
    
    public init(description: String?, location: String?, isLoading: Bool, shouldRetry: Bool, image: Image?) {
        self.description = description
        self.location = location
        self.isLoading = isLoading
        self.shouldRetry = shouldRetry
        self.image = image
    }
    
    public var hasLocation: Bool {
        location != nil
    }
}
