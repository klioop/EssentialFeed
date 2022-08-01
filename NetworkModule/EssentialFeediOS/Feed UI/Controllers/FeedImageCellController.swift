//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

public protocol FeedImageCellControllerDelegate {
    func didRequestFeedImage()
    func didRequestCancelLoadingImage()
}

public final class FeedImageCellController: CellController, ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage
    
    private let viewModel: FeedImageViewModel
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.descriptionLabel.text = viewModel.description
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.onRetry = delegate.didRequestFeedImage
        delegate.didRequestFeedImage()
        
        return cell!
    }
    
    public func display(_ resourceViewModel: ResourceViewModel) {
        cell?.feedImageView.setImageAnimated(resourceViewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }

    public func preload() {
        delegate.didRequestFeedImage()
    }
    
    public func cancelLoad() {
        releaseCellForReuse()
        delegate.didRequestCancelLoadingImage()
    }
    
    func releaseCellForReuse() {
        cell = nil
    }
}
