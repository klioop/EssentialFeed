//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(description: image.description, location: image.location)
    }
}
