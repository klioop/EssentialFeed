//
//  ImageCommentsLocalizationTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/07/30.
//

import XCTest
import NetworkModule

class ImageCommentsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        
        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }
}


