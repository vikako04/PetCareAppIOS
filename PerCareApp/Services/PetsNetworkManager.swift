//
//  PetsNetworkManager.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 02.06.2025.
//

import UIKit



class PetsNetworkManager {
    static let shared = PetsNetworkManager()
    private init() {}

    private let baseURL = "http://localhost:3030/api"
    
    func addPet(name: String, type: String, age: Int, description: String, completion: @escaping (Result<Pet, Error>) -> Void) {
            guard let token = TokenManager.shared.getAccessToken() else {
                completion(.failure(NSError(domain: "No token", code: 401)))
                return
            }

            let url = URL(string: "\(baseURL)/pets")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let body = [
                "name": name,
                "type": type,
                "age": age,
                "description": description
            ] as [String : Any]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                    return
                }

                do {
                    let pet = try JSONDecoder().decode(Pet.self, from: data)
                    completion(.success(pet))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func getPets(completion: @escaping (Result<[Pet], Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }

        let url = URL(string: "\(baseURL)/pets")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Нет данных", code: 0)))
                return
            }

            print(String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")

            do {
                let pets = try JSONDecoder().decode([Pet].self, from: data)
                completion(.success(pets))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deletePet(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }
        
        let url = URL(string: "\(baseURL)/pets/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NSError(domain: "Ошибка удаления", code: 400)))
                return
            }

            completion(.success(()))
        }.resume()
    }


}
