//
//  ViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/2/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    let dashboard = DashboardModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.dashboard.pullStepsAndUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

