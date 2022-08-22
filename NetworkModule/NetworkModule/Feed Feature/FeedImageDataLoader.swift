//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/15.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
