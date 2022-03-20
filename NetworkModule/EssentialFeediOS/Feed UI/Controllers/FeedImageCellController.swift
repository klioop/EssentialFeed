//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

protocol FeedImageCellControllerDelegate {
    func didRequestFeedImage()
    func didRequestCancelLoadingImage()
}

final class FeedImageCellController: FeedImageView {
    private lazy var cell = FeedImageCell()
    
    private let delegate: FeedImageCellControllerDelegate
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        delegate.didRequestFeedImage()
        return cell
    }
    
    func display(_ model: FeedImageViewData<UIImage>) {
        cell.descriptionLabel.text = model.description
        cell.locationContainer.isHidden = !model.hasLocation
        cell.locationLabel.text = model.location
        cell.feedImageContainer.isShimmering = model.isLoading
        cell.feedImageView.image = model.image
        cell.feedImageRetryButton.isHidden = !model.shouldRetry
        cell.onRetry = delegate.didRequestFeedImage
    }
    
    func preload() {
        delegate.didRequestFeedImage()
    }
    
    func cancelLoad() {
        delegate.didRequestCancelLoadingImage()
    }
}
