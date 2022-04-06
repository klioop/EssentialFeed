//
//  FeedPresenterTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/06.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
    
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessage() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
    
}
