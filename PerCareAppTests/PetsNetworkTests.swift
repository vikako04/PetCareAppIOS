//
//  PetsNetworkTests.swift
//  PerCareAppTests
//
//  Created by Виктория Кормачева on 03.06.2025.
//


import XCTest
@testable import PerCareApp

final class PetsNetworkTests: XCTestCase {

    var mockManager: MockPetsNetworkManager!

    override func setUp() {
        super.setUp()
        mockManager = MockPetsNetworkManager()
    }

    override func tearDown() {
        mockManager = nil
        super.tearDown()
    }

    func testAddPetSuccess() {
        let expectation = self.expectation(description: "Pet added")

        mockManager.addPet(name: "Buddy", type: "Dog", age: 3, description: "Friendly dog") { result in
            switch result {
            case .success(let pet):
                XCTAssertEqual(pet.name, "Buddy")
                XCTAssertEqual(pet.type, "Dog")
                XCTAssertEqual(pet.age, 3)
                XCTAssertEqual(pet.description, "Friendly dog")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testAddPetFailure() {
        mockManager.shouldReturnError = true

        let expectation = self.expectation(description: "Add pet should fail")

        mockManager.addPet(name: "Kitty", type: "Cat", age: 2, description: "Cute cat") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testDeletePetSuccess() {
        let expectation = self.expectation(description: "Pet deleted")

        let petId = "test-id-123"
        mockManager.deletePet(id: petId) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.mockManager.deletedPetIds.contains(petId))
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testDeletePetFailure() {
        mockManager.shouldReturnError = true

        let expectation = self.expectation(description: "Delete pet should fail")

        mockManager.deletePet(id: "bad-id") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}

