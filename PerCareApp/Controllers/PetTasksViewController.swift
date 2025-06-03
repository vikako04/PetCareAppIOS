//
//  PetTasksViewController.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import UIKit

class PetTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pet: Pet?
    var tasks: [Task] = []
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        fetchTasks()
    }
    
    func fetchTasks() {
        guard let petId = pet?.id else { return }
        
        TasksNetworkManager.shared.fetchTasks(for: petId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self.tasks = tasks
                    self.tasksTableView.reloadData()
                case .failure(let error):
                    print("Ошибка при получении задач: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTask" {
            if let addVC = segue.destination as? AddPetTaskViewController {
                addVC.pet = pet
            }
        }
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAddTask", sender: self)
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configure(with: task, onToggle: { [weak self] in
                    guard let self = self else { return }
                    guard let taskId = task.id else { return }

                    TasksNetworkManager.shared.toggleTaskCompletion(taskId: taskId) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                self.tasks[indexPath.row].isCompleted.toggle()
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            case .failure(let error):
                                print("Ошибка при обновлении статуса: \(error.localizedDescription)")
                            }
                        }
                    }
                })
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            guard let taskId = taskToDelete.id else { return }
            
            TasksNetworkManager.shared.deleteTask(taskId: taskId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.tasks.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .failure(let error):
                        print("Ошибка при удалении: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
