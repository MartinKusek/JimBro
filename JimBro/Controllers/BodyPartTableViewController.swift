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
    
    var muscles = [Muscle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.separatorStyle = .none
        //tableView.rowHeight = 50
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadMuscles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        //self.centerTitle()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyPartCell", for: indexPath)
        
        cell.textLabel?.text = muscles[indexPath.row].name
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        
        //Detail text label
        let muscle = muscles[indexPath.row]
        var exerciseArray = [String]()
        for exercise in muscle.exercises! {
            exerciseArray.append((exercise as AnyObject).name)
        }
        cell.detailTextLabel?.text = "\(exerciseArray.joined(separator: ", "))"
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
            
            if muscles == [] {
                
                let musclesArray = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Abs", "More"]
                
                for muscle in musclesArray {
                    let muscles = Muscle(context: K.CoreData.context)
                    muscles.name = muscle
                    
                    do {
                        try K.CoreData.context.save()
                    } catch {
                        print("Error saving context \(error)")
                    }
                }
                
                muscles = try K.CoreData.context.fetch(request)
            }
            
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}

//extension BodyPartTableViewController{
//    func centerTitle(){
//        for navItem in(self.navigationController?.navigationBar.subviews)! {
//             for itemSubView in navItem.subviews {
//                 if let largeLabel = itemSubView as? UILabel {
//                    largeLabel.center = CGPoint(x: navItem.bounds.width/2, y: navItem.bounds.height/2)
//                    return;
//                 }
//             }
//        }
//    }
//}
