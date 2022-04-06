//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        let refreshController = feedController.refreshController!
        refreshController.delegate = presentationAdapter
        
        presentationAdapter.presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(refreshController),
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
            errorView: WeakRefVirtualProxy(feedController)
        )
        return feedController
    }
    
    static func makeFeedViewController(title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.title = FeedPresenter.title
        feedController.errorView = ErrorView()
        return feedController
    }
}
