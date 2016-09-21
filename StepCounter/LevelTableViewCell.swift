//
//  LevelTableViewCell.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    var level : Int = 0 {
        didSet {
            self.updateLabels()
        }
    }
    
    var percentage : Double = 0 {
        didSet {
            self.animatePercentage()
        }
    }
    
    var timer : NSTimer = NSTimer()

    @IBOutlet weak var levelProgressBar: UIView!
    
    let bar = UIView()
    
    var count : Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels() {
        //self.levelLabel.text = "Level \(self.level)"
    }
    
    func animatePercentage() {
        let view = self.levelProgressBar
        self.bar.frame = CGRect(x: 0, y: 0, width: 0, height: view.frame.size.height)
        self.bar.backgroundColor = UIColor.redColor()
        view.addSubview(bar)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector:#selector(LevelTableViewCell.setProgress), userInfo: nil, repeats: true)
    }
    
    func setProgress() {
        if count >= 1 {
            self.timer.invalidate()
        } else {
            let portion = 0.001 * (CGFloat(self.percentage) * self.levelProgressBar.frame.size.width)
            self.bar.frame.size.width += portion
            print(self.bar.frame.size.width)
            print(self.bar.frame.size.width / self.levelProgressBar.frame.size.width)
            self.count += 0.001
        }
    }

}
