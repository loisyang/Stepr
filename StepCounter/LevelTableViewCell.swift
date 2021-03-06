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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.lowLevelLabel.text = "Level \(self.levelInfo.level)"
        self.highLevelLabel.text = "Level \(self.levelInfo.level + 1)"
        let ptg = floor(self.levelInfo.pointsToGo)
        self.pointsToGoLabel.text = "\(Util.formatNumber(ptg)) points to go"
    }
    
    func fillLevelBar() {
        self.percentageSlider.setThumbImage(UIImage.init(), for: UIControlState())
        self.percentageSlider.setValue(Float(self.levelInfo.percentage), animated: true)
    }

}
