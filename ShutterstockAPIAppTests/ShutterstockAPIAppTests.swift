//
//  ShutterstockAPIAppTests.swift
//  ShutterstockAPIAppTests
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import XCTest
@testable import ShutterstockAPIApp

class ShutterstockAPIAppTests: XCTestCase {

    var urlRequest: URLRequest?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetGiphyList() {
        let url =
            URL(string: "https://api.shutterstock.com/v2/images/search?page")

        urlRequest = URLRequest(url: url!)

        let authorization = "Bearer v2/ZTk3YzktMGUzZjMtOGYzYjQtNzE0YWUtZjNjMWQtODk1OTYvMjM3OTM1NzE3L2N1c3RvbWVyLzMvTmFOdDJET0hSQko4ZHlDWjNPOXQ1R1k1Njg2MWdCQ1g1WGEyajB1VjZMM3YzeHlHaHRJTlQ0QTZxVkhWQzdLWm1GbGFhemhkOUJTMVpHd2ZydnZzQkdwOUhZSWd3OW1mNFgwSjdXYzllM2FhdjVTZjNTY3BmanYwWEJMT3lPLWtrNkF3OTJrTS0zazgwS0syaTVyTlQzTHY5ZTZkNlBPWVJ4MHEya3JCNVJuM08tbXZPT1dIVmhSbm5nWFMwQjhiY1c0RXdMUzlpdlhxd1NEd2l1NWc1dw"
        urlRequest?.setValue(authorization, forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                XCTAssertEqual(statusCode, 200)
            }
        }
        dataTask.resume()
    }

}
