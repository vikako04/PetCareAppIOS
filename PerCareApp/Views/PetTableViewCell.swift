//
//  PetTableViewCell.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(with pet: Pet) {
            nameLabel.text = pet.name
            typeLabel.text = pet.type.capitalized
            descriptionLabel.text = pet.description
            ageLabel.text = "\(pet.age)"
       }

}
