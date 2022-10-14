//
//  ExerciseTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import UIKit

class ExerciseTableViewController: UITableViewController {
    
    var selectedBodyPart: BodyPart?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedBodyPart?.name)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedBodyPart?.name
    }

    //MARK: - Add action
    
    @IBAction func addExercise(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Exercise", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            var newExercise = Exercise()
            newExercise.name = textField.text!
            
            self.selectedBodyPart?.exercises.append(newExercise)
            
            print(self.selectedBodyPart?.exercises)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        print(selectedBodyPart?.exercises)
        self.tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedBodyPart?.exercises.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        cell.textLabel?.text = selectedBodyPart?.exercises[indexPath.row].name
        return cell
    }
}
