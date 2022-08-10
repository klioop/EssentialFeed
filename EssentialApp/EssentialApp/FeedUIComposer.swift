//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import Combine
import NetworkModule
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void
    ) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(
            loader: { feedLoader().dispatchOnMainQueue() })
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        let refreshController = feedController.refreshController!
            refreshController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() },
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(refreshController),            
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        return feedController
    }
    
    static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}
