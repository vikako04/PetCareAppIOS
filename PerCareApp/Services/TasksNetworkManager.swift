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
        guard let url = URL(string: "\(baseURL)/tasks") else {
            
            return
        }

        let formatter = ISO8601DateFormatter()
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "dueDate": formatter.string(from: dueDate),
            "pet": petId
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                
                return
            }

            do {
                let task = try JSONDecoder().decode(Task.self, from: data)
                completion(.success(task))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


}

