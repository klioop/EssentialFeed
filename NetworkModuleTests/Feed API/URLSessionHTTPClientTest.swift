//
//  URLSessionHTTPClientTest.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/02/12.
//

import Foundation
import XCTest
import NetworkModule

class URLSessionHTTPClient {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSeestionHTTPClientTest: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequest()
        let url = URL(string: "https://any-given-url.com")!
        let requestedError = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: requestedError)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, requestedError.domain)
                XCTAssertEqual(receivedError.code, requestedError.code)
            default:
                XCTFail("Expected failure with error, \(requestedError) got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        URLProtocolStub.stopInterceptingRequest()
    }
    
    // MARK: - Helpers
    
    private class URLProtocolStub: URLProtocol {
        
        private static var stub: Stub?
        
        private struct Stub {
            let data: Data?
            let response: HTTPURLResponse?
            let error: Error?
        }
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        static func stub(data: Data?, response: HTTPURLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        // The URL loading system will instantiate our URLProtocolStub only if we can handle the request. So up to this point, we don't have an instance yet.
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            // If we have an error, we need to tell the URL loading system that an error occured by using an instance property of URLProtocol, client. The protocol uses it to communicate with the URL loading system.
            if let error = URLProtocolStub.stub?.error {
                // Tell the URL loading system that loading failed with an error using client
                client?.urlProtocol(self, didFailWithError: error)
            }
            // Tell the URL loading system that loading for the url finished
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
    
}
