//
//  AddPetViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//

import UIKit

class AddPetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    

    override func viewDidLoad() {
           super.viewDidLoad()


            petTypePicker.dataSource = self
            petTypePicker.delegate = self
            selectedType = petTypes.first
       }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var petTypePicker: UIPickerView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let petTypes = ["Собака",
                    "Кошка",
                    "Хомяк",
                    "Рыбки",
                    "Кролик",
                    "Черепаха",
                    "Морская свинка",
                    "Крыса",
                    "Хорёк",
                    "Змея",
                    "Ящерица",
                    "Попугай",
                    "Еж",
                    "Шиншилла"]
        var selectedType: String?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return petTypes.count
       }



       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return petTypes[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           selectedType = petTypes[row]
       }
    
    
    @IBAction func addPetTapped(_ sender: UIButton) {
            guard
                let name = nameTextField.text, !name.isEmpty,
                let ageText = ageTextField.text, let age = Int(ageText),
                let description = descriptionTextField.text,
                let type = selectedType
            else {
                print("Заполните все поля корректно")
                return
            }

            PetsNetworkManager.shared.addPet(name: name, type: type, age: age, description: description) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pet):
                                    print("Питомец добавлен: \(pet.name)")
                                    
                                    self.dismiss(animated: true) {
                                        if let petsVC = self.presentingViewController as? PetsViewController {
                                            petsVC.fetchPets()
                                        }
                                    }
                    case .failure(let error):
                        print("Ошибка при добавлении: \(error.localizedDescription)")
                    }
                }
                
            }
        }
}
