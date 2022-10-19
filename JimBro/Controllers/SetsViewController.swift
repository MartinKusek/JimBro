//
//  SetsViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import UIKit
import CoreData

class SetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var setsArray = [Sets]()
    
    var todaysDate = Date()
    let TodaysDateFormatter = DateFormatter()
    
    var selectedExercise: Exercise?

    var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        title = selectedExercise?.name
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        TodaysDateFormatter.dateFormat = "d. M. y."
        let date = TodaysDateFormatter.string(from: todaysDate)
        
        let predicate = NSPredicate(format: "date MATCHES %@", date)
        
        loadSets(predicate: predicate)
    }
    
    //MARK: - Add Button Action
    @IBAction func addSetPressed(_ sender: Any) {
        
        var KgTextField = UITextField()
        var RepsTextField = UITextField()
        
        let alert = UIAlertController(title: "Set \(self.setsArray.count + 1):", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Set", style: .default) { (action) in
            
            let textFieldString = "Set \(self.setsArray.count + 1): \(KgTextField.text!) kg x \(RepsTextField.text!) reps"
            
            let newSet = Sets(context: K.CoreData.context)
            newSet.set = textFieldString
            newSet.parentExercise = self.selectedExercise
            
            self.dateFormatter.dateFormat = "d. M. y."
            
            newSet.date = self.dateFormatter.string(from: self.date)
            
            self.setsArray.append(newSet)
            
            self.saveSets()
            self.tableView.separatorStyle = .none
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Kg"
            KgTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Reps"
            RepsTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Previous Sessions Button Action
    
    @IBAction func PreviousSessionsPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "previousToSessions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "previousToSessions" {
            
            let navigationVc = segue.destination as! UINavigationController
            let destinationVc = navigationVc.topViewController as! PreviousSessionsTableViewController
            
            destinationVc.selectedExerciseInSessions = selectedExercise
        }
    }
    
    //MARK: - Model Manuplation Methods
    
    func saveSets() {
        
        do {
            try K.CoreData.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadSets(with request: NSFetchRequest<Sets> = Sets.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let setsPredicate = NSPredicate(format: "parentExercise.name MATCHES %@", selectedExercise!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [setsPredicate, addtionalPredicate])
        } else {
            request.predicate = setsPredicate
        }
        
        do {
            setsArray = try K.CoreData.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setsArray.isEmpty {
            
            let noDataLabel: UILabel = UILabel()
            noDataLabel.text = "No sets added today..."
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        } else {
            self.tableView.backgroundView = nil
        }
        return setsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath)
        let set = setsArray[indexPath.row]
        
        cell.textLabel?.text = set.set
        return cell
    }
    
    //MARK: - Deleting Cells
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            K.CoreData.context.delete(setsArray[indexPath.row])
            do {
                try K.CoreData.context.save()
            } catch {
                print("Error saving context \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            setsArray.remove(at: indexPath.row)
            
            tableView.endUpdates()
        }
    }
    
}
