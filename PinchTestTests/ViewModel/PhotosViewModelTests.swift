//
//  PhotosViewModelTests.swift
//  PinchTestTests
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import XCTest
@testable import PinchTest
class PhotosViewModelTests: XCTestCase {
    var sut = PhotosViewModel(networkManager: NetworkManager<DataType>())
    var mockUrlSession = MockURLSession()
    let albumId = 1
    let id = 1
    let title = "Photo title"
    let url = "Photo url"
    let thumbnailURL = "thumbnail Url"
    lazy var responseDict : [String : Any] = ["albumId" : albumId, "id" : id, "title" : title, "url" : url, "thumbnailUrl" : thumbnailURL]

    override func setUpWithError() throws {
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
        sut.callToData(dataType: DataType.photos(userId: 1), result: [Photos].self)
        mockUrlSession.completionHandler?(responseData, nil ,nil)
        
        //then
        XCTAssertNotNil(mockUrlSession.completionHandler)
    }
    
    func testUserDataRequest_CreatesPhotoAlbum() {
        //when
        //create fake photo album
        var testPhotoAlbum : [Photos]?
        
        var jsonArray = [[String: Any]]()
        jsonArray.append(responseDict)

        let responseData = try! JSONSerialization.data(withJSONObject: jsonArray, options: [])
        
        let completion = { (results:Result<[Photos], Error>) in
            switch results {
            case .success(let photos):
                testPhotoAlbum = photos
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        //fetch data
        sut.networkManager.request(route: DataType.photos(userId: 1), completion: completion)
        mockUrlSession.completionHandler?(responseData, nil ,nil)
        
        //then
        XCTAssertNotNil(testPhotoAlbum)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
