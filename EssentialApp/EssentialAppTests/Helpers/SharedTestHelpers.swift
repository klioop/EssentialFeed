//
//  File.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/04/24.
//

import Foundation
import NetworkModule

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyURL() -> URL {
    URL(string: "https://a-url.com")!
}


func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: .init(), description: "any", location: "any", url: anyURL())]
}
