//
//  PinchTestTests.swift
//  PinchTestTests
//
//  Created by Alfredo Martin-Hinojal Acebal on 7/2/22.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import PinchTest

class NetworkManagerTests: XCTestCase {
    
    var sut : NetworkManager<DataType>!
    var mockUrlSession = MockURLSession()
    let userID = 1
    let id = 1
    let title: String = "Test album"
    lazy var responseDict : [String : Any] = ["id":id, "userId":userID, "title":title]
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager<DataType>()
        sut.session = mockUrlSession
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUserDataRequest_CreatesUser() {
        //when
        //create fake user
        var testAlbum : [Album]?
        
        var jsonArray = [[String: Any]]()
        jsonArray.append(responseDict)

        let responseData = try! JSONSerialization.data(withJSONObject: jsonArray, options: [])
        
        let completion = { (results:Result<[Album], Error>) in
            switch results {
            case .success(let album):
                testAlbum = album
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        //fetch data
        sut.request(route: DataType.albums(page: 1), completion: completion)
        mockUrlSession.completionHandler?(responseData, nil ,nil)
        
        //then
        XCTAssertNotNil(testAlbum)
        XCTAssertNotNil(mockUrlSession.completionHandler)
    }
    
    func testRequest_CallsResumeOfDataTask() {
        let completion = {(results:Result<[Album], Error>) in}
        sut.request(route: DataType.albums(page: 1), completion: completion)
        XCTAssertTrue(mockUrlSession.dataTask.resumeGotCalled)
    }
    
    func testRequest_ThrowsErrorWhenDataIsNil(){
        var theError : Error?
        let completion = { (results:Result<[Album], Error>) in
            switch results {
            case .success(_):
                XCTFail()
            case .failure(let error):
                theError = error
            }
        }
        //fetch data
        sut.request(route: DataType.albums(page: 1), completion: completion)
        mockUrlSession.completionHandler?(nil, nil ,nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testRequest_ThrowsErrorWhenResponseHasError() {
        var theError : Error?
        let completion = { (results:Result<[Album], Error>) in
            switch results {
            case .success(_):
                XCTFail()
            case .failure(let error):
                theError = error
            }
        }
        //fetch data
        sut.request(route: DataType.albums(page: 1), completion: completion)
        var jsonArray = [[String: Any]]()
        jsonArray.append(responseDict)
        
        let responseData = try! JSONSerialization.data(withJSONObject: jsonArray, options: [])
        let error = NSError(domain: "Test Error", code: 401, userInfo: nil)
        mockUrlSession.completionHandler?(responseData, nil, error)
        
        XCTAssertNotNil(theError)
    }
}
extension NetworkManagerTests {
    class MockURLSession : URLSessionProtocol {
        
        func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
            self.request = request
            self.completionHandler = completionHandler
            
            return dataTask
        }
        
        typealias Handler = (Data?, URLResponse?, Error?)
            -> Void
        var completionHandler: Handler?
        var request: URLRequest?
        var dataTask = MockUrlSessionDataTask()
        
    }
    
    class MockUrlSessionDataTask : URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
}

