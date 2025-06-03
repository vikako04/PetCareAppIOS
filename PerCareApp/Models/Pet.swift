//
//  Pet.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 02.06.2025.
//

import Foundation

struct Pet: Codable {
    let id: String?
    let name: String
    let type: String
    let age: Int
    let description: String
    let owner: String
}
