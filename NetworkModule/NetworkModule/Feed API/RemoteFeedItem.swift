//
//  RemoteFeedItem.swift
//  NetworkModule
//
//  Created by klioop on 2022/02/21.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
