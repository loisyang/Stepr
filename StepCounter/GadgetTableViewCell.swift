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
    @IBOutlet weak var activeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.gadgetName.adjustsFontSizeToFitWidth = true
        self.activeCountLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        if let gadget = self.gadget {
            self.gadgetName.text = gadget.name!
            self.activeCountLabel.text = "\(Util.formatNumber(gadget.numActive as! Double)) qty."
        }
    }

}
