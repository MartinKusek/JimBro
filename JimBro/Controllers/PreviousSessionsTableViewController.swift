//
//  PreviousSessionsTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 16.10.2022..
//

import UIKit
import CoreData

class PreviousSessionsTableViewController: UITableViewController {
    
    
    var setsArray = [Sets]()
    var dateArray = [String]()
    var cleanDateArray = [String]()
    
    var todaysDate = Date()
    let TodaysDateFormatter = DateFormatter()
    
    var selectedExerciseInSessions: Exercise? {
        didSet {
            loadSets()
            
            TodaysDateFormatter.dateFormat = "d. M. y."
            let date = TodaysDateFormatter.string(from: todaysDate)
            
            for sets in setsArray {
                if sets.date != date {
                    dateArray.append(sets.date!)
                }
            }
            cleanDateArray = dateArray.removingDuplicates()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dateArray.removingDuplicates().count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell", for: indexPath)
        
        cell.textLabel?.text = "\(String(describing: dateArray.removingDuplicates()[indexPath.row]))"
        
        // Configure the cell...
        
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
            destinationVc.selectedDate = dateArray.removingDuplicates()[indexPath.row]
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
            setsArray = try context.fetch(request)
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
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
