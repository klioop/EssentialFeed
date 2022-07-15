//
//  URLProtocolStub.swift
//  NetworkModuleTests
//
//  Created by klioop on 2022/04/11.
//

import Foundation

class URLProtocolStub: URLProtocol {
    
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
        let requestObserver: ((URLRequest) -> Void)?
    }
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }
    
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
    
    static func observeRequest(observer: @escaping (URLRequest) -> Void) {
        stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
    }
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error, requestObserver: nil)
    }
    
    static func removeStub() {
        stub = nil
    }
    
    // The URL loading system will instantiate our URLProtocolStub only if we can handle the request. So up to this point, we don't have an instance yet.
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let stub = URLProtocolStub.stub else { return }
        
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        // If we have an error, we need to tell the URL loading system that an error occured by using an instance property of URLProtocol, client. The protocol uses it to communicate with the URL loading system.
        if let error = stub.error {
            // Tell the URL loading system that loading failed with an error using client
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            // Tell the URL loading system that loading for the url finished
            client?.urlProtocolDidFinishLoading(self)
        }
        
        stub.requestObserver?(request)
    }
    
    override func stopLoading() {}
}
