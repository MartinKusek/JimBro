//
//  JimBrain.swift
//  JimBro
//
//  Created by Martin Kusek on 21.10.2022..
//

import UIKit

struct JimBrain {
    
    func getMusclesInCoreData() {

        for muscle in K.musclesArray {
            let muscles = Muscle(context: K.CoreData.context)
            muscles.name = muscle
            
            do {
                try K.CoreData.context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
    
    func getNoDataLabel(text: String) -> UILabel {
        
        let noDataLabel: UILabel = UILabel()
        noDataLabel.text = text
        noDataLabel.textColor = UIColor.gray
        noDataLabel.backgroundColor = UIColor.clear
        noDataLabel.textAlignment = NSTextAlignment.center
        return noDataLabel
    }
    
    func getSetsString(set: Int, kg: String, reps: String) -> String {
        
        var stringKg = "\(kg) kg"
        if kg == "" || kg == "0" || kg == "1" {
            stringKg = "Bodyweight"
        }
        
        var stringReps = "\(reps) reps"
        if reps == "" || stringReps == "1" || reps == "0"{
            stringReps = "1 rep"
        }
        
        let setsString = "Set \(set): \(stringKg) x \(stringReps)"
        return setsString
    }
    
    func getDatesFromSets(date: String, sets: [Sets]) -> [String] {
        
        var dateArray = [String]()
        for set in sets {
            if set.date != date {
                dateArray.append(set.date!)
            }
        }
        return dateArray
    }
    
    func getExercisesDetailText(muscle: Muscle) -> String {
        
        var exerciseArray = [String]()
        for exercise in muscle.exercises! {
            exerciseArray.append((exercise as AnyObject).name)
        }
        return exerciseArray.joined(separator: ", ")
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
