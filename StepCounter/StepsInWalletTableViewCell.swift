//
//  StepsInWalletTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class StepsInWalletTableViewCell: UITableViewCell {
    
    var pointsInWallet : Double = 0

    @IBOutlet weak var pointsInWalletLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.pointsInWalletLabel.text = "\(self.pointsInWallet) points in your wallet"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
