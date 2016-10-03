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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
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
                    self.purchaseButton.isHidden = false
                    self.gadgetCostLabel.textColor = UIColor.green
                } else {
                    self.purchaseButton.isHidden = true
                    self.gadgetCostLabel.textColor = UIColor.red
                }
                
            } else if (userLevel.level + 2 >= unlockLevel) {
                // user will unlock in the next two levels
                
                self.gadgetNameLabel.text = gadget.name!
                self.gadgetCostLabel.text = "\(Util.formatNumber(gadget.cost as! Double)) points"
                self.activeCountLabel.isHidden = true
                self.pointsPerStepLabel.isHidden = true
                self.purchaseButton.isHidden = true
                
                self.gadgetNameLabel.textColor = UIColor.gray
                self.gadgetCostLabel.textColor = UIColor.gray
                
            } else {
                // user will unlock in the far future
                
                self.gadgetNameLabel.text = "Unlock at Level \(gadget.unlockLevel as! Int)"
                self.gadgetCostLabel.isHidden = true
                self.activeCountLabel.isHidden = true
                self.pointsPerStepLabel.isHidden = true
                self.purchaseButton.isHidden = true
                
                self.gadgetNameLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    func showAllLabels() {
        self.gadgetNameLabel.isHidden = false
        self.gadgetCostLabel.isHidden = false
        self.activeCountLabel.isHidden = false
        self.pointsPerStepLabel.isHidden = false
    }
    
    func allBlackFont() {
        self.gadgetNameLabel.textColor = UIColor.black
        self.gadgetCostLabel.textColor = UIColor.black
        self.activeCountLabel.textColor = UIColor.black
        self.pointsPerStepLabel.textColor = UIColor.black
    }
    
    @IBAction func purchaseButtonPressed(_ sender: AnyObject) {
        if let gadget = self.gadget {
            if gadget.canPurchase() {
                gadget.addOne()
                self.updateLabels()
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshGadgetStore"), object: nil, userInfo: nil)
    }
}
