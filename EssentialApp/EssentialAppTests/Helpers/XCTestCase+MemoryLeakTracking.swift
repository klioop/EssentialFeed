//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/04/24.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
