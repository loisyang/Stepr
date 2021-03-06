//
//  HighScoreTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    var historyObject : History? {
        didSet {
            self.updateLabels()
        }
    }

    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        if let highScoreObject = self.historyObject {
            self.highScoreLabel.text = "High score: \(Util.formatNumber(floor(Double(highScoreObject.points!)))) points"
        } else {
            self.highScoreLabel.text = "No high score"
        }
    }

}
