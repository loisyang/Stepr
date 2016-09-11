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
            self.updateLabels()
        }
    }

    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.levelLabel.text = "Level \(self.level)"
    }

}
