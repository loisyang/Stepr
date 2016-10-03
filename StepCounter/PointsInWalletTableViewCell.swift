//
//  PointsInWalletTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/19/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class PointsInWalletTableViewCell: UITableViewCell {

    var pointsInWallet : Double = 0.0 {
        didSet {
            self.updateLabels()
        }
    }
    
    @IBOutlet weak var walletLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateLabels() {
        self.walletLabel.adjustsFontSizeToFitWidth = true
        self.walletLabel.text = "\(Util.formatNumber(floor(self.pointsInWallet))) points in your wallet"
    }


}
