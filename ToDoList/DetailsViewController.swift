//
//  DetailsViewController.swift
//  ToDoList
//
//  Created by Yuliya Masalkina on 13.09.2024.
//

import UIKit


class DetailsViewController: UIViewController {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskStepField: UITextField!
    @IBOutlet weak var taskNoteField: UITextField!
    
    var task = Task()
    
    // индекс для проверки какие задачи были дополнены деталями
   var taskIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        taskNameLabel.text = task.name
        taskStepField.text = task.step
        taskNoteField.text = task.note
       
    }


    @IBAction func updateTask(_ sender: Any) {
        task.step = taskStepField.text ?? ""
        task.note = taskNoteField.text ?? ""
        
        do {
            let defaults = UserDefaults.standard
            let data = defaults.data(forKey: "taskArray")
            var array = try JSONDecoder().decode([Task].self, from: data!)
            
                array[taskIndex] = task
                
                let encodedata = try JSONEncoder().encode(array)
                defaults.set(encodedata, forKey: "taskArray")
        } catch {
            print("unable to encode addTask \(error)")
        }  
        
        
    }
   

}
