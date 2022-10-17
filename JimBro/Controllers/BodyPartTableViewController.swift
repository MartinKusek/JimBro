//
//  BodyPartTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 13.10.2022..
//

import UIKit
import CoreData

class BodyPartTableViewController: UITableViewController {
    
    var muscles = [Muscle]()
    //var bodyParts = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Abs", "More"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadMuscles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar =  navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}

        navBar.backgroundColor = UIColor(named: "1D9BF6")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(ciColor: .red)]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return muscles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyPartCell", for: indexPath)
        
        cell.textLabel?.text = muscles[indexPath.row].name
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        //cell.detailTextLabel?.text = "Deadlift, Pull ups, Dips"
        
        return cell
    }
    
     //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "bodyToExercise", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! ExerciseTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedMuscle = muscles[indexPath.row]
        }
    }
    
     //MARK: - Data manipulation Methods
    
    func loadMuscles() {
        
        let request : NSFetchRequest<Muscle> = Muscle.fetchRequest()
        
        do {
            muscles = try context.fetch(request)
            
            if muscles == [] {
                
                let musclesArray = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Abs", "More"]
                
                for muscle in musclesArray {
                    let muscles = Muscle(context: self.context)
                    muscles.name = muscle
                    
                    do {
                      try context.save()
                    } catch {
                       print("Error saving context \(error)")
                    }
                }
                
                muscles = try context.fetch(request)
            }
            
        } catch {
            print("Error loading categories \(error)")
        }
       
        tableView.reloadData()
        
    }
    
}
