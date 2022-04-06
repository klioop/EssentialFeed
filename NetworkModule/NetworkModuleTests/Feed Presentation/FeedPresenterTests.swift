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
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackMemoryLeak(view, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
    
}
