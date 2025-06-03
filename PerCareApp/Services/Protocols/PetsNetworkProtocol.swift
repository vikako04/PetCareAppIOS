//
//  PetsNetworkProtocol.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import Foundation

protocol PetsNetworkProtocol {
    func addPet(name: String, type: String, age: Int, description: String, completion: @escaping (Result<Pet, Error>) -> Void)
    
    func deletePet(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}
