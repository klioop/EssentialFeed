//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/22.
//

import Foundation
import XCTest
import NetworkModule
import EssentialFeediOS

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ resourceViewModel: Any) {}
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.errorMessage
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
