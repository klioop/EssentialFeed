//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let isLoading: Bool
    let shouldRetry: Bool
    let image: Image?
    
    var hasLocation: Bool {
        location != nil
    }
}
