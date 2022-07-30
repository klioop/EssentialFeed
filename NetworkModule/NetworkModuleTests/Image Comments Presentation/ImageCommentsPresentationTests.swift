//
//  ImageCommentsPresentationTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/07/30.
//

import XCTest
import NetworkModule

class ImageCommentsPresentationTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

}
