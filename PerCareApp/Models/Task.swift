//
//  Task.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

struct Task: Codable {
    let id: String?
    let title: String
    let description: String
    let dueDate: String
    let isCompleted: Bool
    let pet: String
}
