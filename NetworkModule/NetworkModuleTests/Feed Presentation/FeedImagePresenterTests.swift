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
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }    
}
