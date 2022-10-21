//
//  SpecificSessionTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 16.10.2022..
//

import UIKit
import CoreData

class SpecificSessionTableViewController: UITableViewController {
    
    var setsArray = [Sets]()
    var selectedExercise: Exercise?
    
    var selectedDate = "" {
        didSet {
            let datePredicate = NSPredicate(format: "date MATCHES %@", selectedDate)
            loadSets(predicate: datePredicate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        tableView.separatorStyle = .none
        title = selectedDate
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specificSetCell", for: indexPath)
        let set = setsArray[indexPath.row]
        
        cell.textLabel?.text = set.set
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
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
