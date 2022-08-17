//
//  FeedLoaderSpy+FeedImageDataLoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/21.
//

import Foundation
import Combine
import NetworkModule
import EssentialFeediOS

class FeedLoaderSpy: FeedImageDataLoader {
    private(set) var feedRequests = [PassthroughSubject<Paginated<FeedImage>, Error>]()
    private(set) var loadMoreRequests = [PassthroughSubject<Paginated<FeedImage>, Error>]()
    
    var loadFeedCallCount: Int {
        feedRequests.count
    }
    
    var loadMoreCallCount: Int {
        loadMoreRequests.count
    }
    
    func loadPublisher() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let publisher = PassthroughSubject<Paginated<FeedImage>, Error>()
        feedRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
        feedRequests[index].send(Paginated(items: feed, loadMorePublisher: { [weak self] in
            self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
        }))
    }
    
    func completeFeedLoadingWithError(at index: Int = 0) {
        feedRequests[index].send(completion: .failure(anyNSError()))
    }
    
    private func loadMorePublisher() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let publisher = PassthroughSubject<Paginated<FeedImage>, Error>()
        loadMoreRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    func completeLoadMore(with feed: [FeedImage] = [], lastPage: Bool = false, at index: Int = 0) {
        loadMoreRequests[index].send(Paginated(
            items: feed,
            loadMorePublisher: lastPage ? nil : { [weak self] in
                self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
    }
    
    func completeLoadMoreWithError(at index: Int = 0) {
        loadMoreRequests[index].send(completion: .failure(anyNSError()))
    }
    
    // MARK: - FeedImageDataLoader
    
    private struct TaskSpy: FeedImageDataLoaderTask {
        let cancelCallBack: () -> Void
        
        func cancel() {
            cancelCallBack()
        }
    }
    
    private(set) var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    
    var loadedImageURLs: [URL] {
        imageRequests.map { $0.url }
    }
    
    private(set) var cancelledImageURLs = [URL]()
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        imageRequests.append((url, completion))
        
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int) {
        imageRequests[index].completion(.failure(anyNSError()))
    }
}
