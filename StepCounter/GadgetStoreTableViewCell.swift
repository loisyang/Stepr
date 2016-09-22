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
    @IBOutlet weak var pointsPerStepLabel: UILabel!
    @IBOutlet weak var activeCountLabel: UILabel!
    @IBOutlet weak var gadgetCostLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gadgetNameLabel.adjustsFontSizeToFitWidth = true
        pointsPerStepLabel.adjustsFontSizeToFitWidth = true
        activeCountLabel.adjustsFontSizeToFitWidth = true
        gadgetCostLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateLabels() {
        if let gadget = self.gadget {
            
            self.allBlackFont()
            
            let userLevel = self.dashboard.getUserLevel()
            let unlockLevel = gadget.unlockLevel as! Int
            if (userLevel.level >= unlockLevel) {
                // gadget is unlocked
                
                self.showAllLabels()
                self.gadgetNameLabel.text = gadget.name!
                self.gadgetCostLabel.text = "\(Util.formatNumber(gadget.cost as! Double)) points"
                let pointsPerStep = Util.formatNumber((gadget.numActive as! Double) * (gadget.bonus as! Double))
                self.activeCountLabel.text = "\(gadget.numActive as! Int) active producing \(pointsPerStep) points per step"
                self.pointsPerStepLabel.text = "Each \(gadget.name!) produces \(Util.formatNumber(gadget.bonus as! Double)) points per step"
                
                if gadget.canPurchase() {
                    self.purchaseButton.hidden = false
                    self.gadgetCostLabel.textColor = UIColor.greenColor()
                } else {
                    self.purchaseButton.hidden = true
                    self.gadgetCostLabel.textColor = UIColor.redColor()
                }
                
            } else if (userLevel.level + 2 >= unlockLevel) {
                // user will unlock in the next two levels
                
                self.gadgetNameLabel.text = gadget.name!
                self.gadgetCostLabel.text = "\(Util.formatNumber(gadget.cost as! Double)) points"
                self.activeCountLabel.hidden = true
                self.pointsPerStepLabel.hidden = true
                self.purchaseButton.hidden = true
                
                self.gadgetNameLabel.textColor = UIColor.grayColor()
                self.gadgetCostLabel.textColor = UIColor.grayColor()
                
            } else {
                // user will unlock in the far future
                
                self.gadgetNameLabel.text = "Unlock at Level \(gadget.unlockLevel as! Int)"
                self.gadgetCostLabel.hidden = true
                self.activeCountLabel.hidden = true
                self.pointsPerStepLabel.hidden = true
                self.purchaseButton.hidden = true
                
                self.gadgetNameLabel.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    func showAllLabels() {
        self.gadgetNameLabel.hidden = false
        self.gadgetCostLabel.hidden = false
        self.activeCountLabel.hidden = false
        self.pointsPerStepLabel.hidden = false
    }
    
    func allBlackFont() {
        self.gadgetNameLabel.textColor = UIColor.blackColor()
        self.gadgetCostLabel.textColor = UIColor.blackColor()
        self.activeCountLabel.textColor = UIColor.blackColor()
        self.pointsPerStepLabel.textColor = UIColor.blackColor()
    }
    
    @IBAction func purchaseButtonPressed(sender: AnyObject) {
        if let gadget = self.gadget {
            if gadget.canPurchase() {
                gadget.addOne()
                self.updateLabels()
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("refreshGadgetStore", object: nil, userInfo: nil)
    }
}
