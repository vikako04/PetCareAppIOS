//
//  TokenManager.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//


import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() {}

    func saveTokens(access: String, refresh: String) {
        UserDefaults.standard.set(access, forKey: "accessToken")
        UserDefaults.standard.set(refresh, forKey: "refreshToken")
    }

    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }

    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }

    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}


