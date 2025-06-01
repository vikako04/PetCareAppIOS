//
//  RegisterViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//

import UIKit

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
                  let email = emailTextField.text,
                  let password = passwordTextField.text else { return }

            NetworkManager.shared.register(username: username, email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        print("Регистрация успешна: \(user)")
                        
                        TokenManager.shared.saveTokens(access: user.accessToken, refresh: user.refreshToken)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                            tabBarVC.modalPresentationStyle = .fullScreen
                            self.present(tabBarVC, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print("Ошибка регистрации: \(error.localizedDescription)")
                    }
                }
            }
    }
}
