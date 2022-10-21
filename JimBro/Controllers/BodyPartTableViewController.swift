//
//  BodyPartTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 13.10.2022..
//

import UIKit
import CoreData

class BodyPartTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var jimBrain = JimBrain()
    var muscles = [Muscle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadMuscles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyPartCell", for: indexPath)
        let muscle = muscles[indexPath.row]
        
        cell.textLabel?.text = muscle.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        
        cell.detailTextLabel?.text = jimBrain.getExercisesDetailText(muscle: muscle)
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
            muscles = try K.CoreData.context.fetch(request)
            
            if muscles.isEmpty {
                jimBrain.getMusclesInCoreData()
                muscles = try K.CoreData.context.fetch(request)
            }
            
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
}
