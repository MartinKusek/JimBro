//
//  ExerciseTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import UIKit
import CoreData

class ExerciseTableViewController: UITableViewController {
    
    var jimBrain = JimBrain()
    var exerciseArray = [Exercise]()
    
    var selectedMuscle: Muscle? {
        didSet {
            loadExercises()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor(rgb: 0xFBC403)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedMuscle!.name
    }
    
    //MARK: - Add action
    
    @IBAction func addExercise(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.isEmpty == false {
                let newExercise = Exercise(context: K.CoreData.context)
                newExercise.name = textField.text!
                newExercise.parentMuscle = self.selectedMuscle
                
                self.exerciseArray.append(newExercise)
                
                self.saveExercises()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Exercise name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:  {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if exerciseArray.isEmpty {
            self.tableView.backgroundView = jimBrain.getNoDataLabel(text: "No exercises added yet")
        } else {
            self.tableView.backgroundView = nil
        }
        return exerciseArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        let exercise = exerciseArray[indexPath.row]
        
        cell.textLabel?.text = exercise.name
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
        let exerciseForDeletion = exerciseArray[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            for sets in exerciseForDeletion.sets! {
                K.CoreData.context.delete(sets as! NSManagedObject)
            }
            
            K.CoreData.context.delete(exerciseForDeletion)
            do {
                try K.CoreData.context.save()
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
            try K.CoreData.context.save()
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
            exerciseArray = try K.CoreData.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}
