//
//  TodaysDataTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class TodaysDataTableViewCell: UITableViewCell {
    
    var steps : Int = 0 {
        didSet {
            self.updateLabels()
        }
    }
    var points : Double = 0 {
        didSet {
            self.updateLabels()
        }
    }
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.stepsLabel.text = "\(Util.formatNumber(Double(self.steps))) steps"
        self.pointsLabel.text = "\(Util.formatNumber(floor(self.points))) points"
    }
}
