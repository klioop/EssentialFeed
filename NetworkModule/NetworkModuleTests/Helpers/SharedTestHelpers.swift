//
//  SharedTestHelpers.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/24.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-given-url.com")!
}
