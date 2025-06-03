//
//  PetTasksViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import UIKit

class PetTasksViewController: UIViewController{
    
    var pet: Pet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pet = pet {
            print("🐶 Питомец: \(pet.name)")
        } else {
            print("❌ Питомец не передан")
        }
    }

    
    @IBAction func addTaskTapped(_ sender: Any) {
    }
    
}
