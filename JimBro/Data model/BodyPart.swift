//
//  BodyPart.swift
//  JimBro
//
//  Created by Martin Kusek on 14.10.2022..
//

import Foundation

struct JimBro {
    var bodyParts = [BodyPart.init(name: "Back"),
                     BodyPart.init(name: "Chest"),
                     BodyPart.init(name: "Legs"),
                     BodyPart.init(name: "Arms"),
                     BodyPart.init(name: "Shoulders"),
                     BodyPart.init(name: "Abs"),
                     BodyPart.init(name: "More")]
}

struct BodyPart {
    var name: String
    var exercises: [Exercise] = []
}



