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
    
    var jimBrain = JimBrain()
    var setsArray = [Sets]()
    var selectedExercise: Exercise?

    var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        tableView.separatorStyle = .none

        
        title = selectedExercise?.name
        configureTableView()
        
        dateFormatter.dateFormat = "d. M. y."
        let date = dateFormatter.string(from: date)
        
        let predicate = NSPredicate(format: "date MATCHES %@", date)
        
        loadSets(predicate: predicate)
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //MARK: - Add Button Action
    @IBAction func addSetPressed(_ sender: Any) {
        
        var KgTextField = UITextField()
        var RepsTextField = UITextField()
        
        let alert = UIAlertController(title: "Set \(self.setsArray.count + 1):", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newSet = Sets(context: K.CoreData.context)
            newSet.set = self.jimBrain.getSetsString(set: self.setsArray.count + 1, kg: KgTextField.text!, reps: RepsTextField.text!)
            newSet.parentExercise = self.selectedExercise
                        
            newSet.date = self.dateFormatter.string(from: self.date)
            
            self.setsArray.append(newSet)
            
            self.saveSets()
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
        present(alert, animated: true, completion:  {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Previous Sessions Button Action
    
    @IBAction func PreviousSessionsPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "previousToSessions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "previousToSessions" {
            
            let navigationVc = segue.destination as! UINavigationController
            let destinationVc = navigationVc.topViewController as! PreviousSessionsTableViewController
            
            destinationVc.selectedExercise = selectedExercise
        }
    }
    
  
    
    //MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setsArray.isEmpty {
            self.tableView.backgroundView = jimBrain.getNoDataLabel(text: "No sets added yet")
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
    
}
