//
//  HighScoreTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    var dashboard : DashboardModel?

    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set data to label
        if let highScoreObject = self.dashboard!.getHighScore() {
            self.highScoreLabel.text = "High score: \(highScoreObject.points) points"
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
