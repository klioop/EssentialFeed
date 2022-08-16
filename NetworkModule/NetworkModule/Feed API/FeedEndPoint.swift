//
//  FeedEndPoint.swift
//  NetworkModule
//
//  Created by klioop on 2022/08/09.
//

import Foundation

public enum FeedEndPoint {
    case get
    
    public func url(with baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + "/v1/feed"
        components.queryItems = [
            .init(name: "limit", value: "10")
        ]
        return components.url!
    }
}