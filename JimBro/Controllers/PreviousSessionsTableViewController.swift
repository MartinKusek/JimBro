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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateArray.isEmpty {
            
            let noDataLabel: UILabel = UILabel()
            noDataLabel.text = "No previous sessions"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        } else {
            self.tableView.backgroundView = nil
        }
        return dateArray.removingDuplicates().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell", for: indexPath)
        
        cell.textLabel?.text = "\(String(describing: dateArray.removingDuplicates()[indexPath.row]))"
        
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
