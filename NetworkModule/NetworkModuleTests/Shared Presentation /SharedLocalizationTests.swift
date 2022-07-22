//
//  SharedLocalizationTests.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/07/22.
//

import XCTest
import NetworkModule

class SharedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        
        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {
        func display(_ resourceViewModel: Any) {}
    }
}
