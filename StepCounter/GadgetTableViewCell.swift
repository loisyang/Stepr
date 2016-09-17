//
//  GadgetTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class GadgetTableViewCell: UITableViewCell {
    
    var gadget : Gadget? {
        didSet {
            self.updateLabels()
        }
    }

    @IBOutlet weak var gadgetName: UILabel!
    @IBOutlet weak var pointsPerStepsLabel: UILabel!
    @IBOutlet weak var totalActiveLabel: UILabel!
    @IBOutlet weak var activeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        if let gadget = self.gadget {
            self.gadgetName.text = gadget.name!
            
            let pointsPerStep = Util.formatNumber((gadget.numActive as! Double) * (gadget.bonus as! Double))
            self.pointsPerStepsLabel.text = "Each \(gadget.name!) produces \(Util.formatNumber(gadget.bonus as! Double)) points per step"
            self.totalActiveLabel.text = "\(gadget.numActive as! Int) active producing \(pointsPerStep) points per step"
            self.activeCountLabel.text = "\(gadget.numActive as! Int)"
        }
    }

}
