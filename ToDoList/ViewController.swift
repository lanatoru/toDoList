//
//  ViewController.swift
//  ToDoList
//
//  Created by Yuliya Masalkina on 11.09.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTextField: UITextField!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: Any) {
        let defaults = UserDefaults.standard
        let taskName = labelTextField.text!
        let taskNote = noteTextField.text!
        
        var newTask = Task()
        newTask.name = taskName
        newTask.note = taskNote
        
        do {
            if let data = defaults.data(forKey: "taskArray") {
                var array = try JSONDecoder().decode([Task].self, from: data)
                
                array.append(newTask)
                
                let encodedata = try JSONEncoder().encode(array)
                
                defaults.set(encodedata, forKey: "taskArray")
            } else {
                let encodedata = try JSONEncoder().encode([newTask])
                
                defaults.set(encodedata, forKey: "taskArray")
            }
        } catch {
            print("unable to encode addTask \(error)")
        }
        
        
        labelTextField.text = " "
        noteTextField.text = " "
    }
    
}

