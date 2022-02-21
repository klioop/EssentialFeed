//
//  FeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping(LoadFeedResult) -> Void)
}
