//
//  TodaysDataTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class TodaysDataTableViewCell: UITableViewCell {
    
    var steps : Int = 0
    var points : Double = 0

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Apply data to labels
        self.stepsLabel.text = "\(self.steps) steps"
        
        self.pointsLabel.text = "\(self.points) points"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
