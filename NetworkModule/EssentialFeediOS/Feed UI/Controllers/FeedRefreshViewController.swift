//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

public final class FeedRefreshViewController: NSObject, ResourceLoadingView {
    @IBOutlet private var view: UIRefreshControl?
    
    public var onRefresh: (() -> Void)?
    
    @IBAction func refresh() {
        onRefresh?()
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
}
