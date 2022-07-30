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
    
    public var hasLocation: Bool {
        location != nil
    }
}
