//
//  ViewController.swift
//  Challenge_2
//
//  Created by PC on 5.11.2024.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, AddTaskDelegateProtocol {
    
    var tableView = UITableView()
    var tasks : [String] = []
    let addVCPage = AddTaskViewController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(AddTasks))
        navigationItem.rightBarButtonItem = addButton
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadTasks()
        
    }
    func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: "tasks")
    }

    func loadTasks() {
        tasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
    }
   
    
    func didTaskAdd(newTask: String) {
        tasks.append(newTask)
        saveTasks()
        tableView.reloadData()
    }
    func didTaskEdit(newTask: String, at index: Int) {
        tasks[index] = newTask  // Update the task in the array
        saveTasks()
        tableView.reloadData()  // Reload the table view
    }
    @objc func AddTasks (){
        addVCPage.taskTextView.text = nil
        addVCPage.EditTaskButton.isHidden = true
        addVCPage.AddNewTaskButton.isHidden = false
        addVCPage.delegate = self  // ViewController'ı delegate olarak atıyoruz
        navigationController!.pushViewController(addVCPage, animated: true)
    }
    func editButtonTapped(at indexPath: IndexPath) {
        addVCPage.delegate = self  // Set delegate to self
        addVCPage.taskFromMainPage = tasks[indexPath.row] // Pass task to the new VC
        addVCPage.indexToEdit = indexPath.row  // Pass the index of the task
        addVCPage.taskTextView.text = tasks[indexPath.row]
        addVCPage.AddNewTaskButton.isHidden = true
        addVCPage.EditTaskButton.isHidden = false
        navigationController?.pushViewController(addVCPage, animated: true)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        
        let situationButton = UIButton()
        situationButton.translatesAutoresizingMaskIntoConstraints = false
        situationButton.setImage(UIImage(systemName: "square"), for: .normal) // fist seem
        situationButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected) // when selected
        situationButton.addTarget(self, action: #selector(TappedSituation), for: .touchUpInside)
        
        cell.contentView.addSubview(situationButton)
        
        NSLayoutConstraint.activate([
            situationButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
            situationButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5),
            situationButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5),
            situationButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.editButtonTapped(at: indexPath)
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let alert = UIAlertController(title: "Warning message", message: "Do you want to delete your task", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let delete = UIAlertAction(title: "Delete", style: .destructive){ _ in
                //once diziden sonra tablodan silinmeli.
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true)
            
            completionHandler(false)

        }
        editAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction,deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    @objc func TappedSituation(sender : UIButton){
        sender.isSelected.toggle()
    }
    


}

