//
//  AddPetTaskViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import UIKit

class AddPetTaskViewController: UIViewController {

    var pet: Pet!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var descriptionLabel: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    @IBAction func addTaskTapped(_ sender: UIButton) {
  
            guard
                let title = titleLabel.text, !title.isEmpty,
                let description = descriptionLabel.text,
                let petId = pet.id
            else {
                print("Пожалуйста, заполните все поля")
                return
            }

            let dueDate = datePicker.date

            TasksNetworkManager.shared.addTask(
                title: title,
                description: description,
                dueDate: dueDate,
                petId: petId
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let task):
                        print("Задача добавлена: \(task.title)")
                        self.dismiss(animated: true)
                    case .failure(let error):
                        print("Ошибка при добавлении задачи: \(error.localizedDescription)")
                    }
                }
            }
        }

    }
    
