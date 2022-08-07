//
//  CommentsUIIntegrationTests.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/08/07.
//

import XCTest
import UIKit
import Combine
import NetworkModule
import EssentialFeediOS
import EssentialApp

class CommentsUIIntegrationTests: FeedUIIntegrationTests {
    
    func test_commentsView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, commentsTitle)
    }
    
    func test_loadCommentsActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view is loades")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiateReLoad()
        XCTAssertEqual(loader.loadCommentsCallCount, 2,  "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiateReLoad()
        XCTAssertEqual(loader.loadCommentsCallCount, 3, "Expected a third loading request once user initiates another load")
    }
    
    override func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading()
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
                        
        sut.simulateUserInitiateReLoad()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes with error")
    }
    
    override func test_loadFeedCompeltion_rendersErrorMessageOnErrorUnitlNextReload() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message on view loaded")
        
        loader.completeFeedLoadingWithError()
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiateReLoad()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message on feed reload")
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message on view loaded")
        
        loader.completeFeedLoadingWithError()
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorMessageTapped()
        XCTAssertEqual(sut.errorMessage, nil, "Expected no error message when the message is tapped")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CommentsUIComposer.commentsComposedWith(commentsLoader: loader.loadPublisher)
        trackMemoryLeak(loader, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class LoaderSpy {
        private(set) var requests = [PassthroughSubject<[FeedImage], Error>]()
                        
        var loadCommentsCallCount: Int {
            requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
            let publisher = PassthroughSubject<[FeedImage], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            requests[index].send(feed)
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }
}
