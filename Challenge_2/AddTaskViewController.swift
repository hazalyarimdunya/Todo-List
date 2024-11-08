//
//  AddTaskViewController.swift
//  Challenge_2
//
//  Created by PC on 5.11.2024.
//

import UIKit

protocol AddTaskDelegateProtocol : AnyObject{
    func didTaskAdd(newTask:String)
    func didTaskEdit(newTask:String,at index : Int)
}
class AddTaskViewController: UIViewController {
    
    var delegate : AddTaskDelegateProtocol?
    var indexToEdit : Int?
    var taskFromMainPage : String?
    
    let taskTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let AddNewTaskButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        return button
    }()
    let EditTaskButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        return button
    }()
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.backgroundColor = .gray
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.alpha = 0
        view.backgroundColor = .systemBackground
        view.addSubview(taskTextView)
        view.addSubview(AddNewTaskButton)
        view.addSubview(EditTaskButton)
        view.addSubview(infoLabel)
        AddNewTaskButton.addTarget(self, action: #selector(AddTaskButton), for: .touchUpInside)
        EditTaskButton.addTarget(self, action: #selector(EditTask), for: .touchUpInside)

        setColors()
        ConfigureConstraints()
        
        taskTextView.text = taskFromMainPage //Sayfa acildigi gibi tablodaki degeri buradaki textview a ekle
        
    }
    
    @objc func AddTaskButton(){
        if let  taskText = taskTextView.text, !taskText.isEmpty{
            delegate?.didTaskAdd(newTask: taskText)
            navigationController?.popViewController(animated: true) //bir onceki sayfaya donus
            
        }
        else{
            showLabelWithDelay()
            infoLabel.text = "Write a new task"
            
        }
    }
    @objc func EditTask(){
        //pass the updated task back to the delegate
        if let  taskText = taskTextView.text, !taskText.isEmpty{
            if let updatedTask = taskTextView.text, let index = indexToEdit {
                delegate?.didTaskEdit(newTask: updatedTask, at: index)
                    }
            navigationController?.popViewController(animated: true) //bir onceki sayfaya donus
            
        }
    }
    
    func showLabelWithDelay() {
           // Show the label with an animation
           UIView.animate(withDuration: 0.5) {
               self.infoLabel.alpha = 1
           }
           
           // Delay before hiding the label
           let delayInSeconds = 2.0 // Set the delay duration here
           DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
               self.hideLabelWithAnimation()
           }
       }
       
       func hideLabelWithAnimation() {
           UIView.animate(withDuration: 0.5) { // Animate to fade-out
               self.infoLabel.alpha = 0
           }
       }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
            setColors()
        }
    }
    func setColors() {
        if traitCollection.userInterfaceStyle == .dark {
           taskTextView.backgroundColor = .white
           taskTextView.textColor = .black
           AddNewTaskButton.backgroundColor = .white
           AddNewTaskButton.setTitleColor(.black, for: .normal)
           EditTaskButton.backgroundColor = .white
           EditTaskButton.setTitleColor(.black, for: .normal)
           
           }
        else {
               taskTextView.backgroundColor = .black
               taskTextView.textColor = .white
               AddNewTaskButton.backgroundColor = .black
               AddNewTaskButton.setTitleColor(.white, for: .normal)
               EditTaskButton.backgroundColor = .black
               EditTaskButton.setTitleColor(.white, for: .normal)
               
           }
       }
    func ConfigureConstraints(){
        NSLayoutConstraint.activate([
            taskTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTextView.heightAnchor.constraint(equalToConstant: 200),
            taskTextView.widthAnchor.constraint(equalToConstant: 200),
            
            AddNewTaskButton.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 20),
            AddNewTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AddNewTaskButton.heightAnchor.constraint(equalToConstant: 50),
            AddNewTaskButton.widthAnchor.constraint(equalToConstant: 120),
            
            EditTaskButton.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 20),
            EditTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            EditTaskButton.heightAnchor.constraint(equalToConstant: 50),
            EditTaskButton.widthAnchor.constraint(equalToConstant: 120),
            
            infoLabel.topAnchor.constraint(equalTo: AddNewTaskButton.bottomAnchor, constant: 20),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 50),
            infoLabel.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    

}
