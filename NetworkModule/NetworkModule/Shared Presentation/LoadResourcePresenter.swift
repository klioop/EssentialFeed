//
//  LoadResourcePresenter.swift
//  NetworkModule
//
//  Created by klioop on 2022/07/19.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ resourceViewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    public let mapper: Mapper
    private let resourceView: View
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public var errorMessage: String {
        NSLocalizedString("GENERIC_CONNECTION_ERROR",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Error message displayed when we can't load feed from the server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(FeedErrorViewModel.error(message: errorMessage))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
