//
//  NetworkManager.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//

import UIKit

struct AuthResponse: Codable {
    let id: String
    let username: String
    let email: String
    let accessToken: String
    let refreshToken: String
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "http://localhost:3030/api/auth"

    func register(username: String, email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["username": username, "email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getProfile(completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }

        let url = URL(string: "\(baseURL)/profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Нет данных", code: 0)))
                return
            }

            do {
                let jsonString = String(data: data, encoding: .utf8)
                print("Ответ: \(jsonString ?? "nil")")

                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                print("Ошибка декодирования: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }


    
}

