//
//  FeedImageDataCache.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/29.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
