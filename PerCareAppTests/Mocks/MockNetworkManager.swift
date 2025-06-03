//
//  MockNetworkManager.swift
//  PerCareAppTests
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import Foundation
@testable import PerCareApp


class MockNetworkManager: NetworkProtocol {
    var shouldReturnError = false
    var registeredUsername: String?
    var loggedInEmail: String?
    var profileRequested = false

    func register(username: String, email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        registeredUsername = username
        if shouldReturnError {
            completion(.failure(MockError.testError))
        } else {
            let response = AuthResponse(
                id: "123",
                username: username,
                email: email,
                accessToken: "mock_access_token",
                refreshToken: "mock_refresh_token"
            )
            completion(.success(response))
        }
    }

}

enum MockError: Error {
    case testError
}
