//
//  FeedLoader.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/08.
//

import Foundation

enum FeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping([FeedResult]) -> Void)
}
