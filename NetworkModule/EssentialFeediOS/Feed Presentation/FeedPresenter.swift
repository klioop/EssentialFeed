//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/16.
//

import Foundation
import NetworkModule

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let feedView: FeedView
    
    init(loadingView: FeedLoadingView, feedView: FeedView) {
        self.loadingView = loadingView
        self.feedView = feedView
    }
    
    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.global().async { [weak self ] in self?.didStartLoadingFeed()}
        }
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.global().async { [weak self ] in self?.didFinishLoadingFeed(with: feed)}
        }
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.global().async { [weak self ] in self?.didFinishLoadingFeed(with: error)}
        }
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
