//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

public protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefesh()
}

public final class FeedRefreshViewController: NSObject, ResourceLoadingView {
    @IBOutlet private var view: UIRefreshControl?
    
    public var delegate: FeedRefreshViewControllerDelegate?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefesh()
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
}
