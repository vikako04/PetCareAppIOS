//
//  PetsViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 01.06.2025.
//

import UIKit

class PetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
   
    @IBOutlet weak var petsTableView: UITableView!
    var pets: [Pet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        petsTableView.dataSource = self
        petsTableView.delegate = self
        fetchPets()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPets()
    }

        func fetchPets() {
            PetsNetworkManager.shared.getPets { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pets):
                        self?.pets = pets
                        self?.petsTableView.reloadData()
                    case .failure(let error):
                        print("Ошибка загрузки питомцев:", error.localizedDescription)
                    }
                }
            }
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = pets[indexPath.row]
        performSegue(withIdentifier: "ShowPetTasks", sender: selectedPet)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPetTasks",
           let destinationVC = segue.destination as? PetTasksViewController,
           let selectedPet = sender as? Pet {
            destinationVC.pet = selectedPet
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pets.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let pet = pets[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as? PetTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configure(with: pet)
            return cell
        }
    

    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let petToDelete = pets[indexPath.row]
            guard let petId = petToDelete.id else {
                    print("Ошибка: у питомца нет id")
                    return
                }
            PetsNetworkManager.shared.deletePet(id: petId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.pets.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .failure(let error):
                        print("Ошибка при удалении: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}
