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
    }
}
