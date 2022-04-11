//
//  HTTPURLResponse+StatusCode.swift
//  NetworkModule
//
//  Created by klioop on 2022/04/11.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
