//
//  PreviousSessionsTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 16.10.2022..
//

import UIKit
import CoreData

class PreviousSessionsTableViewController: UITableViewController {
    
    var brain = JimBrain()
    var setsArray = [Sets]()
    var cleanDateArray = [String]()
    
    var date = Date()
    let dateFormatter = DateFormatter()
    
    var selectedExerciseInSessions: Exercise? {
        didSet {
            loadSets()
            
            dateFormatter.dateFormat = "d. M. y."
            let date = dateFormatter.string(from: date)
            
            cleanDateArray = brain.getDatesFromSets(date: date, sets: setsArray).removingDuplicates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cleanDateArray.isEmpty {
            self.tableView.backgroundView = brain.getNoDataLabel(text: "No previous sessions")
        } else {
            self.tableView.backgroundView = nil
        }
        return cleanDateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell", for: indexPath)
        let setDate = cleanDateArray[indexPath.row]
        
        cell.textLabel?.text = "\(setDate)"
        
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "sessionsToSpecific", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! SpecificSessionTableViewController
        
        destinationVc.selectedExerciseInSpecificSessions = selectedExerciseInSessions
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedDate = cleanDateArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func loadSets(with request: NSFetchRequest<Sets> = Sets.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let setsPredicate = NSPredicate(format: "parentExercise.name MATCHES %@", selectedExerciseInSessions!.name!)
        
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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
