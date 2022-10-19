//
//  ExerciseTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import UIKit
import CoreData

class ExerciseTableViewController: UITableViewController {
    
    var exerciseArray = [Exercise]()
    
    var selectedMuscle: Muscle? {
        didSet {
            loadExercises()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("number of rows is empty \(tableView.numberOfRows(inSection: 0))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedMuscle!.name
    }
    
    //MARK: - Add action
    
    @IBAction func addExercise(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Exercise", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let newExercise = Exercise(context: self.context)
            newExercise.name = textField.text!
            newExercise.parentMuscle = self.selectedMuscle
            
            self.exerciseArray.append(newExercise)
            
            self.saveExercises()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if exerciseArray.isEmpty {
            
            let noDataLabel: UILabel = UILabel()
            noDataLabel.text = "No exercises added yet..."
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        } else {
            self.tableView.backgroundView = nil
        }
        return exerciseArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        let item = exerciseArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        return cell
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "exerciseToSets", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! SetsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedExercise = exerciseArray[indexPath.row]
        }
    }
    
    //MARK: - Deleting Cells
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()

            context.delete(exerciseArray[indexPath.row])
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            exerciseArray.remove(at: indexPath.row)
            
            tableView.endUpdates()
        }
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveExercises() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadExercises(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let exercisePredicate = NSPredicate(format: "parentMuscle.name MATCHES %@", selectedMuscle!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [exercisePredicate, addtionalPredicate])
        } else {
            request.predicate = exercisePredicate
        }
        
        
        do {
            exerciseArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
}
