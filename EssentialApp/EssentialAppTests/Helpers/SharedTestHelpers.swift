//
//  File.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/04/24.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyURL() -> URL {
    URL(string: "https://a-url.com")!
}
