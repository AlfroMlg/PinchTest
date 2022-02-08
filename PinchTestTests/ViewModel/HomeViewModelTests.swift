//
//  HomeViewModelTests.swift
//  PinchTestTests
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import XCTest
@testable import PinchTest
class HomeViewModelTests: XCTestCase {

    var sut = HomeViewModel(networkManager: NetworkManager<DataType>())
    var mockUrlSession = MockURLSession()
    let userID = 1
    let id = 1
    let title: String = "Test album"
    lazy var responseDict : [String : Any] = ["id":id, "userId":userID, "title":title]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut.networkManager.session = mockUrlSession
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCallToData() throws {
        //when
        
        var jsonArray = [[String: Any]]()
        jsonArray.append(responseDict)

        let responseData = try! JSONSerialization.data(withJSONObject: jsonArray, options: [])
        
        //fetch data
        sut.callToData(dataType: DataType.albums(page: 1), result: [Album].self)
        mockUrlSession.completionHandler?(responseData, nil ,nil)
        
        //then
        XCTAssertNotNil(mockUrlSession.completionHandler)
    }
    
    func testUserDataRequest_CreatesAlbum() {
        //when
        //create fake album
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
        sut.networkManager.request(route: DataType.albums(page: 1), completion: completion)
        mockUrlSession.completionHandler?(responseData, nil ,nil)
        
        //then
        XCTAssertNotNil(testAlbum)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
