//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import UIKit
import NetworkModule

final class FeedImageCellController: FeedImageView {
    private lazy var cell = FeedImageCell()
    
    let loadImageData: () -> Void
    let cancelImageDataLoad: () -> Void
    
    init(loadImageData: @escaping () -> Void, cancelImageDataLoad: @escaping () -> Void) {
        self.loadImageData = loadImageData
        self.cancelImageDataLoad = cancelImageDataLoad
    }
    
    func view() -> UITableViewCell {
        loadImageData()
        return cell
    }
    
    func display(_ model: FeedImageViewData<UIImage>) {
        cell.descriptionLabel.text = model.description
        cell.locationContainer.isHidden = !model.hasLocation
        cell.locationLabel.text = model.location
        cell.feedImageContainer.isShimmering = model.isLoading
        cell.feedImageView.image = model.image
        cell.feedImageRetryButton.isHidden = !model.shouldRetry
        cell.onRetry = loadImageData
    }
    
    func preload() {
        loadImageData()
    }
    
    func cancelLoad() {
        cancelImageDataLoad()
    }
}
