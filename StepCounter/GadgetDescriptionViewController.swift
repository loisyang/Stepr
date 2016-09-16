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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let gadget = self.gadget {
            self.gadgetNameLabel.text = gadget.name!
            self.gadgetCostLabel.text = "\(gadget.cost as! Int) points"
            self.gadgetCountLabel.text = "\(gadget.numActive as! Int) active"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
