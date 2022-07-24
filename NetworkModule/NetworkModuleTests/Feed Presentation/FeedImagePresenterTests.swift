//
//  FeedImagePresenterTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/07/24.
//

import XCTest
import NetworkModule

class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniuqeImage()
        
        let viewModel = FeedImagePresenter<ViewSpy, AnyImage>.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
    
    private class ViewSpy: FeedImageView {
        func display(_ model: FeedImageViewModel<AnyImage>) {}
    }
    
    private struct AnyImage: Equatable {}
}
