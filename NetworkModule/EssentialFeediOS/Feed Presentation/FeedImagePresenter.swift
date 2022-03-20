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
    private let view: View
    private let imageTransFormer: (Data) -> Image?
        
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransFormer = imageTransformer
    }
    
    struct InvalidDataError: Error {}
   
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewData(description: model.description, location: model.location, isLoading: true, shouldRetry: false, image: nil))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransFormer(data) else {
            return didFinishLoadingImageData(with: InvalidDataError(), for: model)
        }
        view.display(FeedImageViewData(description: model.description, location: model.location, isLoading: false, shouldRetry: false, image: image))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewData(description: model.description, location: model.location, isLoading: false, shouldRetry: true, image: nil))
    }
}
