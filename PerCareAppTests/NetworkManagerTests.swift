//
//  NetworkManagerTests.swift
//  PerCareAppTests
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import XCTest
@testable import PerCareApp

final class NetworkManagerTests: XCTestCase {

    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }

    func testRegisterSuccess() {
        let expectation = self.expectation(description: "Register success")

        mockNetworkManager.register(username: "testUser", email: "test@email.com", password: "password") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.username, "testUser")
                XCTAssertEqual(response.email, "test@email.com")
                XCTAssertEqual(response.accessToken, "mock_access_token")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(mockNetworkManager.registeredUsername, "testUser")
    }

    func testRegisterFailure() {
        mockNetworkManager.shouldReturnError = true

        let expectation = self.expectation(description: "Register failure")

        mockNetworkManager.register(username: "testUser", email: "test@email.com", password: "password") { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}

