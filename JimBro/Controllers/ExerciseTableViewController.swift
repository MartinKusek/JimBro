//
//  ExerciseTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import UIKit
import CoreData

class ExerciseTableViewController: SwipeTableViewController {
    
    var exerciseArray = [Exercise]()
    
    var selectedMuscle: Muscle? {
        didSet {
            loadExercises()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(exerciseArray.count)
        print(exerciseArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedMuscle!.name
        tableView.separatorStyle = .none
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
            print(self.exerciseArray.count)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Exercise Name..."
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tableView.numberOfSections, "broj sekcija")

        //return exerciseArray.count ?? 1
        switch exerciseArray.count == 0 {
            case true:
            print("RETURNA 1")
                return 1
            case false:
            print("RETURNA 2")
                return exerciseArray.count
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch exerciseArray.count == 0 {
            case true:
            print("OVO RADI SRANJE")
                /// No content
                tableView.insertRows(at: [indexPath], with: .none)
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyTableViewCell", for: indexPath)
                cell.textLabel?.text = "No Exercises Added Yet..."
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.textLabel?.textColor = .gray
                return cell
            case false:
                /// User cell
                let cell = super.tableView(tableView, cellForRowAt: indexPath)
                cell.textLabel?.text = exerciseArray[indexPath.row].name
                return cell
            }

    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if exerciseArray.count != 0 {
            performSegue(withIdentifier: "exerciseToSets", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! SetsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedExercise = exerciseArray[indexPath.row]
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        context.delete(exerciseArray[indexPath.row])
        exerciseArray.remove(at: indexPath.row)
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}
