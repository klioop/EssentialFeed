//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/22.
//

import XCTest
import NetworkModule

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }
}
