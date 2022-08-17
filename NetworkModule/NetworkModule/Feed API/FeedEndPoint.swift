//
//  FeedEndPoint.swift
//  NetworkModule
//
//  Created by klioop on 2022/08/09.
//

import Foundation

public enum FeedEndPoint {
    case get(after: FeedImage? = nil)
    
    public func url(with baseURL: URL) -> URL {
        switch self {
        case let .get(image):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                .init(name: "limit", value: "10"),
                image.map { URLQueryItem(name: "after_id", value: $0.id.uuidString) },
            ].compactMap { $0 }
            return components.url!
        }
    }
}
