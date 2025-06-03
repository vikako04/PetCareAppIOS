//
//  TasksNetworkManager.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import Foundation


class TasksNetworkManager {
    static let shared = TasksNetworkManager()
    private init() {}
    
    private let baseURL = "http://localhost:3030/api"
    
    func addTask(title: String, description: String, dueDate: Date, petId: String, completion: @escaping (Result<Task, Error>) -> Void) {
        
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "No token", code: 401)))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/tasks/\(petId)") else {
            
            return
        }

        let formatter = ISO8601DateFormatter()
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "dueDate": formatter.string(from: dueDate),
            "pet": petId
        ]

        print("Тело запроса:")
        print(body)

        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON:")
            print(jsonString)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Ответ сервера:\n\(responseString)")
            }

            do {
                let task = try JSONDecoder().decode(Task.self, from: data)
                completion(.success(task))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    func fetchTasks(for petId: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }
        guard let url = URL(string: "\(baseURL)/tasks/\(petId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Ответ:\n\(responseString)")
            }

            do {
                let tasks = try JSONDecoder().decode([Task].self, from: data)
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteTask(taskId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/tasks/\(taskId)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }

    func toggleTaskCompletion(taskId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = TokenManager.shared.getAccessToken() else {
            completion(.failure(NSError(domain: "Нет токена", code: 401)))
            return
        }

        guard let url = URL(string: "\(baseURL)/tasks/\(taskId)/toggle") else {
            completion(.failure(NSError(domain: "Неверный URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }.resume()
    }


}

