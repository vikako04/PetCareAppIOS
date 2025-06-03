//
//  TaskTableViewCell.swift
//  PerCareApp
//
//  Created by Виктория Кормачева on 03.06.2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var completionSwitch: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var toggleHandler: (() -> Void)?
    @IBAction func switchChanged(_ sender: UISwitch) {
        toggleHandler?()
    }
    
    func configure(with task: Task, onToggle: @escaping () -> Void) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        completionSwitch.isOn = task.isCompleted
        toggleHandler = onToggle
        
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = isoFormatter.date(from: task.dueDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd.MM.yyyy"
            dateLabel.text = displayFormatter.string(from: date)
        } else {
            print("Не удалось распарсить дату: \(task.dueDate)")
            dateLabel.text = "Неизвестно"
        }
    }
}
