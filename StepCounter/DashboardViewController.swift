//
//  ViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/2/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dashboard = DashboardModel()
    
    var activeGadgets : [Gadget] {
        return Gadget.getActiveGadgets()
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Designate this class as the tableView delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set a timer to reload the tableView data
        // This must be done because of the asynchronicity of the requests to HealthKit
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(DashboardViewController.updateTableData), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableData() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + self.activeGadgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysDataTableViewCell") as! TodaysDataTableViewCell
            cell.steps = self.dashboard.getStepsForToday()
            cell.points = self.dashboard.getPointsForToday()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell") as! LevelTableViewCell
            cell.levelInfo = self.dashboard.getUserLevel()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell") as! HighScoreTableViewCell
            cell.historyObject = self.dashboard.getHighScore()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GadgetTableViewCell") as! GadgetTableViewCell
            cell.gadget = self.activeGadgets[(indexPath as NSIndexPath).row - 3]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).row {
        case 0:
            return CGFloat(100)
        case 1:
            return CGFloat(90)
        case let x where x >= 3:
            return CGFloat(45)
        default:
            return CGFloat(44)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath as NSIndexPath).row >= 3 {
            self.performSegue(withIdentifier: "dashboardToGadgetDescriptionSegue", sender: self.activeGadgets[(indexPath as NSIndexPath).row - 3])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gadgetDescriptionVC = segue.destination as! GadgetDescriptionViewController
        gadgetDescriptionVC.gadget = sender as? Gadget
    }
}

