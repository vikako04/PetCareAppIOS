//
//  NetworkManagerProtocol.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import Foundation

protocol NetworkProtocol {
    func register(username: String, email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void)
    
}
