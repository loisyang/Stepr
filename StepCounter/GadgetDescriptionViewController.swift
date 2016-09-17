//
//  GadgetDescriptionViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/14/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class GadgetDescriptionViewController: UIViewController {
    
    var gadget : Gadget?
    
    @IBOutlet weak var gadgetNameLabel: UILabel!
    @IBOutlet weak var gadgetCostLabel: UILabel!
    @IBOutlet weak var gadgetCountLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.updateLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        if let gadget = self.gadget {
            self.gadgetNameLabel.text = gadget.name!
            self.gadgetCostLabel.text = "\(Util.formatNumber(gadget.cost as! Double)) points"
            self.gadgetCountLabel.text = "\(gadget.numActive as! Int) active"
            
            if !gadget.canPurchase() {
                self.purchaseButton.hidden = true
            }
        }
        
    }
    
    @IBAction func purchasePressed(sender: AnyObject) {
        if let gadget = self.gadget {
            if gadget.canPurchase() {
                gadget.addOne()
                self.updateLabels()
            }
        }
    }
}
