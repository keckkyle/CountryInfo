//
//  CountryInfoTests.swift
//  CountryInfoTests
//
//  Created by Kyle Keck on 5/4/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import XCTest

@testable import CountryInfo

class CountryInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCountryAPI() throws {
        let capi = CountryAPI()
        
        let expectation = self.expectation(description: "This worked")
        
        var didPass:Bool = false
        
        capi.getCountries { result, error in
            if error != nil {
                print(error)
                return
            }

            if let countries = result {
                for country in countries {
                    print(country.name)
                }
            }
            didPass = true
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(didPass)
    }
    
    func testImage() throws {
        let wiapi = WebImage()
        
        let expectation = self.expectation(description: "This worked")
        
        var didPass:Bool = false
        
        wiapi.getImage(from: "https://flagpedia.net/data/flags/normal/xk.png"){ result, error in
            if error != nil {
                print(error)
                return
            }
            if let imageData = result {
                let image = UIImage(data: imageData)
            }
            didPass = true
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(didPass)
    }
    
}
