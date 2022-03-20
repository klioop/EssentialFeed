//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation
import NetworkModule

struct FeedImageViewData<Image> {
    let description: String?
    let location: String?
    let isLoading: Bool
    let shouldRetry: Bool
    let image: Image?
    
    var hasLocation: Bool {
        location != nil
    }
}

protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewData<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransFormer: (Data) -> Image?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransFormer = imageTransformer
    }
    
    var view: View?
    
    func loadImageData() {
        view?.display(FeedImageViewData(description: model.description, location: model.location, isLoading: true, shouldRetry: false, image: nil))
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransFormer) {
            view?.display(FeedImageViewData(description: model.description, location: model.location, isLoading: false, shouldRetry: false, image: image))
        } else {
            view?.display(FeedImageViewData(description: model.description, location: model.location, isLoading: false, shouldRetry: true, image: nil))
        }
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
}
