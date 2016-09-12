//
//  ViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/2/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dashboard = DashboardModel()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Designate this class as the tableView delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dashboard.pullStepsAndUpdate()
        
        // Set a timer to reload the tableView data
        // This must be done because of the asynchronicity of the requests to HealthKit
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(DashboardViewController.updateTableData), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableData() {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("StepsInWalletTableViewCell") as! StepsInWalletTableViewCell
            cell.pointsInWallet = self.dashboard.getPointsInWallet()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("TodaysDataTableViewCell") as! TodaysDataTableViewCell
            cell.steps = self.dashboard.getStepsForToday()
            cell.points = self.dashboard.getPointsForToday()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("LevelTableViewCell") as! LevelTableViewCell
            let levelInfo = self.dashboard.getUserLevel()
            cell.level = levelInfo.level
            cell.percentage = levelInfo.percentage
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("HighScoreTableViewCell") as! HighScoreTableViewCell
            cell.historyObject = self.dashboard.getHighScore()
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Normal Cell"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return CGFloat(100)
        default:
            return CGFloat(44)
        }
    }


}

