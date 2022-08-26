//
//  ImageDataMapper.swift
//  NetworkModule
//
//  Created by klioop on 2022/08/20.
//

import Foundation

public final class ImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else { throw Error.invalidData }
        
        return data
    }
}

