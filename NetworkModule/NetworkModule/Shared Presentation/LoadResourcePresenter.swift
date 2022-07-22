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
    
    public static var errorMessage: String {
        NSLocalizedString("GENERIC_CONNECTION_ERROR",
                          tableName: "Shared",
                          bundle: Bundle(for: Self.self),
                          comment: "Error message displayed when we can't load resource from the server")
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
        errorView.display(FeedErrorViewModel.error(message: Self.errorMessage))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
