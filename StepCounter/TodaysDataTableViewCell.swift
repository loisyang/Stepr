//
//  TodaysDataTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class TodaysDataTableViewCell: UITableViewCell {
    
    var dashboard : DashboardModel?

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Apply data to labels
        let steps = self.dashboard!.getStepsForToday()
        self.stepsLabel.text = "\(steps) steps"
        
        let points = self.dashboard!.getPointsForToday()
        self.pointsLabel.text = "\(points) points"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
