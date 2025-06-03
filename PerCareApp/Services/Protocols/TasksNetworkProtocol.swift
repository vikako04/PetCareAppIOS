//
//  TasksNetworkManagerProtocol.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import Foundation

protocol TasksNetworkProtocol {
    
    func toggleTaskCompletion(taskId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
