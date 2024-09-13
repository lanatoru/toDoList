//
//  TableViewController.swift
//  ToDoList
//
//  Created by Yuliya Masalkina on 11.09.2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var arrayTask:[Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        do {
            if let data = defaults.data(forKey: "taskArray") {
                let array = try JSONDecoder().decode([Task].self, from: data)
                
                arrayTask = array
            }
        } catch {
            print("unable to encode viewWillAppear \(error)")
        }
        
        tableView.reloadData()
    }
    
    // долгое нажатие для изменения статуса isCompleted
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let point = gesture.location(in: self.tableView)
                
                if let indexPath = tableView.indexPathForRow(at: point) {
                  
                    arrayTask[indexPath.row].isComplete.toggle()
                    
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    
                }
            }
        }
    
    func saveTasks() {
        let defaults = UserDefaults.standard
        
        do {
                
                let encodedata = try JSONEncoder().encode(arrayTask)
                
                defaults.set(encodedata, forKey: "taskArray")
            } catch {
            print("unable to encode saveTasks \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayTask.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = arrayTask[indexPath.row]

       //  Configure the cell...
        
        cell.textLabel?.text = arrayTask[indexPath.row].name
        
        
        // если задача выполнена, зачеркнуть
        if task.isComplete {
                    // перечеркивание текста если задача выполнена
                    let attributedString = NSAttributedString(
                        string: task.name,
                        attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                    )
                    cell.textLabel?.attributedText = attributedString
                    cell.textLabel?.textColor = .gray
                } else {
                    let attributedString = NSAttributedString(string: task.name)
                    cell.textLabel?.attributedText = attributedString
                    cell.textLabel?.textColor = .black
                }

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailsVC.task = arrayTask[indexPath.row]
        detailsVC.taskIndex = indexPath.row
        
        navigationController?.show(detailsVC, sender: self)
        
        //arrayTask[indexPath.row].isComplete.toggle()
        
        tableView.reloadData()
        
        saveTasks()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            arrayTask.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
