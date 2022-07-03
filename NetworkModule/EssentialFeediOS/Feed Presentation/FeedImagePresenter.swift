//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/20.
//

import Foundation
import NetworkModule

public protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransFormer: (Data) -> Image?
        
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransFormer = imageTransformer
    }
    
    struct InvalidDataError: Error {}
   
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location, isLoading: true, shouldRetry: false, image: nil))
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransFormer(data) else {
            return didFinishLoadingImageData(with: InvalidDataError(), for: model)
        }
        view.display(FeedImageViewModel(description: model.description, location: model.location, isLoading: false, shouldRetry: false, image: image))
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location, isLoading: false, shouldRetry: true, image: nil))
    }
}
