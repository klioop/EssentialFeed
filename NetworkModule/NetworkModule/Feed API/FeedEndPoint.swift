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
        baseURL.appendingPathComponent("/v1/feed")
    }
}
