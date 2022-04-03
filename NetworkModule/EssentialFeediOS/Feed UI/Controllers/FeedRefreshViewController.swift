//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefesh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet private var view: UIRefreshControl?
    
    var delegate: FeedRefreshViewControllerDelegate?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefesh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
}
