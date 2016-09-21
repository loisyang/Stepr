//
//  LevelTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    var level : Int = 0 {
        didSet {
            self.updateLabels()
        }
    }
    
    var percentage : Double = 0 {
        didSet {
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
        self.lowLevelLabel.text = "Level \(self.level)"
        self.highLevelLabel.text = "Level \(self.level + 1)"
    }
    
    func fillLevelBar() {
        self.percentageSlider.setThumbImage(UIImage.init(), forState: UIControlState.Normal)
        self.percentageSlider.setValue(Float(self.percentage), animated: true)
    }

}
