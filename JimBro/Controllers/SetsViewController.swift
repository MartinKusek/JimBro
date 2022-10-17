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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedExercise?.name
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        TodaysDateFormatter.dateFormat = "d. M. y."
        let date = TodaysDateFormatter.string(from: todaysDate)
        
        let request : NSFetchRequest<Sets> = Sets.fetchRequest()
        let predicate = NSPredicate(format: "date MATCHES %@", date)
        
        loadSets(with: request, predicate: predicate)
        
    }
    
    //MARK: - Add Button Action
    @IBAction func addSetPressed(_ sender: Any) {
        
        var KgTextField = UITextField()
        var RepsTextField = UITextField()
        
        let alert = UIAlertController(title: "Set \(self.setsArray.count + 1):", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Set", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let textFieldString = "Set \(self.setsArray.count + 1): \(KgTextField.text!) kg x \(RepsTextField.text!) reps"
            
            let newSet = Sets(context: self.context)
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
            try context.save()
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
            setsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return setsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath)
        let set = setsArray[indexPath.row]
        
        cell.textLabel?.text = set.set
        return cell
    }
    
    
    //MARK: - Table View Delegate
    
    
}
