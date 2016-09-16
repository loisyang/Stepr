//
//  GadgetStoreTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/15/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class GadgetStoreTableViewCell: UITableViewCell {
    
    let dashboard = DashboardModel()
    
    var gadget : Gadget? {
        didSet {
            self.updateLabels()
        }
    }
    
    @IBOutlet weak var gadgetNameLabel: UILabel!
    @IBOutlet weak var gadgetCostLabel: UILabel!
    @IBOutlet weak var gadgetCountLabel: UILabel!

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
            let userLevel = self.dashboard.getUserLevel()
            let unlockLevel = gadget.unlockLevel as! Int
            self.gadgetNameLabel.text = gadget.name!
            self.gadgetCostLabel.text = "\(gadget.formattedCost) points"
            self.gadgetCountLabel.text = "\(gadget.numActive as! Int)"
//            if (userLevel.level >= unlockLevel) {
//                // gadget is unlocked
//                self.gadgetNameLabel.text = gadget.name!
//                self.gadgetCostLabel.text = "\(gadget.cost as! Int) points"
//                self.gadgetCountLabel.text = "\(gadget.numActive as! Int)"
//            } else if (userLevel.level + 2 >= unlockLevel) {
//                // user will unlock in the next two levels
//                self.gadgetNameLabel.text = gadget.name!
//                self.gadgetCostLabel.text = "\(gadget.cost as! Int) points"
//                self.gadgetCountLabel.text = "--"
//            } else {
//                // user will unlock in the far future
//                self.gadgetNameLabel.text = "??????"
//                self.gadgetCostLabel.text = "??????"
//                self.gadgetCountLabel.text = "--"
//            }
        }
    }

}
