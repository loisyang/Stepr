//
//  AchievementTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 10/3/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {
    
    var achievement : Achievement? {
        didSet {
            self.updateLabels()
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var achievedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.nameLabel.adjustsFontSizeToFitWidth = true
        if let achievement = achievement {
            self.nameLabel.text = achievement.name
            if achievement.isAchieved() {
                self.achievedLabel.isHidden = false
            } else {
                self.achievedLabel.isHidden = true
            }
        }
    }

}
