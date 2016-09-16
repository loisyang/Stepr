//
//  GadgetStoreTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/15/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class GadgetStoreTableViewCell: UITableViewCell {
    
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
            self.gadgetNameLabel.text = gadget.name!
            self.gadgetCostLabel.text = "\(gadget.cost as! Int) points"
            self.gadgetCountLabel.text = "\(gadget.numActive as! Int)"
        }
    }

}
