//
//  SharedTestHelpers.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/24.
//

import Foundation
import NetworkModule

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-given-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeItemJSON(_ items: [[String: Any]]) -> Data {
    let json = [
        "items": items
    ]
    return try! JSONSerialization.data(withJSONObject: json)
}

func uniqueFeed() -> FeedImage {
    FeedImage(id: .init(), description: "any", location: "any", url: anyURL())
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
