//
//  FeedImageLoaderPresentationAdater.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/23.
//

import NetworkModule
import EssentialFeediOS

final class FeedImageLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private var task: FeedImageDataLoaderTask?
    
    let model: FeedImage
    let imageLoader: FeedImageDataLoader
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestFeedImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didRequestCancelLoadingImage() {
        task?.cancel()
        task = nil
    }
    
}
