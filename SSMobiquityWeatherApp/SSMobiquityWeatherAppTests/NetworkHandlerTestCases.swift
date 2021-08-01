//
//  NetworkHandlerTestCases.swift
//  SSMobiquityWeatherAppTests
//
//  Created by Suraj Shandil on 8/1/21.
//

import XCTest
@testable import SSMobiquityWeatherApp
class NetworkHandlerTestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testWeatherReportAynchronousAPICall() {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?appid=fae7190d7e6433ec3a45285ffcf55c86&q=Washington")
        let expectation = self.expectation(description: "Get \(url!)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error,"error should be nil")
            if let httpResponse = response as? HTTPURLResponse
            {
                XCTAssertEqual(httpResponse.statusCode, 200, "Network response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            expectation.fulfill()
        }
        task.resume()
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                task.cancel()
            }
    }
}
