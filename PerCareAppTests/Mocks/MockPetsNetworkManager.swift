//
//  MockPetsNetworkManager.swift
//  PerCareAppTests
//
//  Created by Виктория Кормачева on 03.06.2025.
//


import Foundation
@testable import PerCareApp

class MockPetsNetworkManager: PetsNetworkProtocol {

    var shouldReturnError = false
    var addedPets: [Pet] = []
    var deletedPetIds: [String] = []

    func addPet(name: String, type: String, age: Int, description: String, completion: @escaping (Result<Pet, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.mockError))
        } else {
            let mockPet = Pet(id: UUID().uuidString, name: name, type: type, age: age, description: description, owner: "mock-owner-id")

            addedPets.append(mockPet)
            completion(.success(mockPet))
        }
    }

    func deletePet(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.mockError))
        } else {
            deletedPetIds.append(id)
            completion(.success(()))
        }
    }

    enum MockError: Error {
        case mockError
    }
}
