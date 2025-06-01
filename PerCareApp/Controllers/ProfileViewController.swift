//
//  ProfileViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//

import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadUserProfile()
        }

        func loadUserProfile() {
            NetworkManager.shared.getProfile { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.usernameLabel.text = user.username
                        self.emailLabel.text = user.email
                    case .failure(let error):
                        print("Ошибка загрузки профиля: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        TokenManager.shared.clearTokens()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let authTabBar = storyboard.instantiateViewController(withIdentifier: "AuthTabBarController") as? UITabBarController {
               authTabBar.modalPresentationStyle = .fullScreen

               if let window = UIApplication.shared.connectedScenes
                   .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                   .first {
                   window.rootViewController = authTabBar
                   window.makeKeyAndVisible()
               }
           }
    }
    
}
    
