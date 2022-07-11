//
//  FeedImageLoaderPresentationAdater.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/23.
//

import Foundation
import Combine
import NetworkModule
import EssentialFeediOS

final class FeedImageLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private var cancellable: Cancellable?
    
    let model: FeedImage
    let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestFeedImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        cancellable = imageLoader(model.url).sink { [weak self] completion in
            switch completion {
            case .finished: break
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        } receiveValue: { [weak self] data in
            self?.presenter?.didFinishLoadingImageData(with: data, for: model)
        }
    }
    
    func didRequestCancelLoadingImage() {
        cancellable?.cancel()
    }
    
}
