//
//  LoadResourcePresenter.swift
//  NetworkModule
//
//  Created by klioop on 2022/07/19.
//

import Foundation

public protocol ResourceView {
    func display(_ resourceViewModel: String)
}

public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    public let mapper: Mapper
    private let resourceView: ResourceView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public var errorMessage: String {
        NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Error message displayed when we can't load feed from the server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel.error(message: errorMessage))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
