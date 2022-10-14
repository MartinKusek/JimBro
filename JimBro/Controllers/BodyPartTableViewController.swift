//
//  BodyPartTableViewController.swift
//  JimBro
//
//  Created by Martin Kusek on 13.10.2022..
//

import UIKit

class BodyPartTableViewController: UITableViewController {

    var jimBro = JimBro()
    //var bodyParts = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Abs", "More"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(jimBro)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar =  navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}

        navBar.backgroundColor = UIColor(named: "1D9BF6")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(ciColor: .red)]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jimBro.bodyParts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyPartCell", for: indexPath)
        
        cell.textLabel?.text = jimBro.bodyParts[indexPath.row].name
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        cell.detailTextLabel?.text = "Deadlift, Pull ups, Dips"
        
        return cell
    }
    
     //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "bodyToExercise", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination as! ExerciseTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedBodyPart = jimBro.bodyParts[indexPath.row]
        }
    }
}
