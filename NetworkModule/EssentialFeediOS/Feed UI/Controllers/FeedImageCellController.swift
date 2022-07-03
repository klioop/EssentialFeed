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

public final class FeedImageCellController: FeedImageView {
    private var cell: FeedImageCell?
    
    private let delegate: FeedImageCellControllerDelegate
    
    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestFeedImage()
        return cell!
    }
    
    public func display(_ model: FeedImageViewModel<UIImage>) {
        cell?.descriptionLabel.text = model.description
        cell?.locationContainer.isHidden = !model.hasLocation
        cell?.locationLabel.text = model.location
        cell?.feedImageContainer.isShimmering = model.isLoading
        cell?.feedImageView.setImageAnimated(model.image)
        cell?.feedImageRetryButton.isHidden = !model.shouldRetry
        cell?.onRetry = delegate.didRequestFeedImage
    }
    
    func preload() {
        delegate.didRequestFeedImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didRequestCancelLoadingImage()
    }
    
    func releaseCellForReuse() {
        cell = nil
    }
}
