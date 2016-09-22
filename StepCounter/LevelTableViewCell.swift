//
//  LevelTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    var levelInfo : (level: Int, percentage: Double, pointsToGo: Double) = (0, 0.0, 0.0) {
        didSet {
            self.updateLabels()
            self.fillLevelBar()
        }
    }
    
    @IBOutlet weak var lowLevelLabel: UILabel!
    @IBOutlet weak var highLevelLabel: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var pointsToGoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.lowLevelLabel.text = "Level \(self.levelInfo.level)"
        self.highLevelLabel.text = "Level \(self.levelInfo.level + 1)"
        self.pointsToGoLabel.text = "\(Util.formatNumber(self.levelInfo.pointsToGo)) points to go"
    }
    
    func fillLevelBar() {
        self.percentageSlider.setThumbImage(UIImage.init(), forState: UIControlState.Normal)
        self.percentageSlider.setValue(Float(self.levelInfo.percentage), animated: true)
    }

}
