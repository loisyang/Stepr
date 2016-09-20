//
//  GadgetStoreViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/14/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit
import CoreData

class GadgetStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //let gadgetsModel = GadgetsModel()
    var gadgetList : [Gadget] {
        return Gadget.getAllGadgets()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Designate this class as the tableView delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GadgetStoreViewController.updateTableData), name: "refreshGadgetStore", object: nil)
        
        self.updateTableData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableData() {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.gadgetModel.numberOfGadgetsAvailable()
        return 1 + self.gadgetList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("PointsInWalletTableViewCell") as! PointsInWalletTableViewCell
            cell.pointsInWallet = DashboardModel().getPointsInWallet()
            cell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("GadgetStoreTableViewCell") as! GadgetStoreTableViewCell
            cell.gadget = self.gadgetList[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row > 0 {
            let gadget = self.gadgetList[indexPath.row - 1]
            if gadget.isUnlocked() {
                return CGFloat(85)
            }
            return CGFloat(40)
        } else {
            return CGFloat(50)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let gadget = self.gadgetList[indexPath.row - 1]
        if gadget.isUnlocked() {
            self.performSegueWithIdentifier("gadgetStoreToGadgetDescriptionSegue", sender: gadget)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gadgetDescriptionVC = segue.destinationViewController as! GadgetDescriptionViewController
        gadgetDescriptionVC.gadget = sender as? Gadget
    }
    
    
    
}
