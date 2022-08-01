//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/07/03.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected navigation controller as a root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is ListViewController, "Expected a feed view controller as a top view controller, got \(String(describing: topController)) instead")
    }
}
