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
    
    struct UnexpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}

class URLSesstionHTTPClientTest: XCTestCase {
    
    override class func setUp() {
        URLProtocolStub.startInterceptingRequest()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for observe request")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestedError = NSError(domain: "any error", code: 1)
        let receivedError = resultedError(data: nil, response: nil, error: requestedError)! as NSError
        
        XCTAssertEqual(receivedError.domain, requestedError.domain)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        let anyData = Data("any Data".utf8)
        let anyError = NSError(domain: "any error", code: 1)
        let nonHttpURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let anyHttpURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        XCTAssertNotNil(resultedError(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultedError(data: nil, response: nonHttpURLResponse, error: nil))
        XCTAssertNotNil(resultedError(data: nil, response: anyHttpURLResponse, error: nil))
        XCTAssertNotNil(resultedError(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultedError(data: anyData, response: nil, error: anyError))
        XCTAssertNotNil(resultedError(data: anyData, response: nonHttpURLResponse, error: anyError))
        XCTAssertNotNil(resultedError(data: anyData, response: anyHttpURLResponse, error: anyError))
        XCTAssertNotNil(resultedError(data: anyData, response: nonHttpURLResponse, error: nil))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackMemoryLeak(sut, file: file, line: line)
        
        return sut
    }
    
    private func anyURL() -> URL {
        return  URL(string: "https://any-given-url.com")!
    }
    
    private func resultedError(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        sut.get(from: anyURL()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure with error got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        return receivedError
    }
    
    private class URLProtocolStub: URLProtocol {
        
        private static var stub: Stub?
        private static var receivedRequest: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            receivedRequest = nil
        }
        
        static func observeRequest(observer: @escaping (URLRequest) -> Void) {
            receivedRequest = observer
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        // The URL loading system will instantiate our URLProtocolStub only if we can handle the request. So up to this point, we don't have an instance yet.
        override class func canInit(with request: URLRequest) -> Bool {
            receivedRequest?(request)
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
