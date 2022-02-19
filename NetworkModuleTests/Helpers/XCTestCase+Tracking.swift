//
//  XCTestCase+Tracking.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/13.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instacne should have been deallocated. Potential Memory leak.", file: file, line:  line)
        }
    }
}
    
