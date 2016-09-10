//
//  StepsInWalletTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class StepsInWalletTableViewCell: UITableViewCell {
    
    var dashboard : DashboardModel?

    @IBOutlet weak var pointsInWalletLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let pointsInWallet = self.dashboard!.getPointsInWallet()
        self.pointsInWalletLabel.text = "\(pointsInWallet) points in your wallet"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
