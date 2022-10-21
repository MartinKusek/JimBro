//
//  Constants.swift
//  JimBro
//
//  Created by Martin Kusek on 19.10.2022..
//

import UIKit
import CoreData

struct K {
    static let appName = "JimBro"
    static let musclesArray = ["Back", "Chest", "Legs", "Arms", "Shoulders", "Abs", "More"]
    
    struct CoreData {
        static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        static let path = "FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)"
    }
}
