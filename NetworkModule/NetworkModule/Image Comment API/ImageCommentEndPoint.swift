//
//  ImageCommentEndPoint.swift
//  NetworkModule
//
//  Created by klioop on 2022/08/09.
//

import Foundation

public enum ImageCommentEndPoint {
    case get(UUID)
    
    public func url(with baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
