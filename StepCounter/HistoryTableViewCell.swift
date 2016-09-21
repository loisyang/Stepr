//
//  HistoryTableViewCell.swift
//  Stepr
//
//  Created by Ziyun Zheng on 9/20/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//
//
//  HistoryTableViewCell.swift
//  Stepr
//
//  Created by Ziyun Zheng on 9/20/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    var histroy : History? {
        didSet {
            self.updateLabels()
        }
    }
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var steps: UILabel!
    
    @IBOutlet weak var points: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateLabels() {
        if let history = self.histroy {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            self.date.text = String(dateFormatter.stringFromDate(history.date!))
            self.steps.text = "\(Util.formatNumber(history.steps as! Double)) steps"
            self.points.text = "\(Util.formatNumber(history.points as! Double)) points"
        }
    }
    
}
