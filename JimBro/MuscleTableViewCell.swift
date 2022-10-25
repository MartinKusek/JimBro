//
//  MuscleTableViewCell.swift
//  JimBro
//
//  Created by Martin Kusek on 24.10.2022..
//

import UIKit

class MuscleTableViewCell: UITableViewCell {
    @IBOutlet weak var counteinerView: UIView!
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var muscleView: UIView!
    @IBOutlet weak var muscleImage: UIImageView!
    
    @IBOutlet weak var muscleLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundView.layer.borderWidth = 1.5
        roundView.layer.cornerRadius = 6
        roundView.layer.borderColor = UIColor(rgb: 0xFBC403).cgColor
        
        muscleView.layer.cornerRadius = 6
        
        arrowView.layer.cornerRadius = 6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
