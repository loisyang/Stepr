//
//  GadgetStoreViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/14/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class GadgetStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //let gadgetsModel = GadgetsModel()
    let gadgetList = ["test", "test2", "test3"]
    
    var testGadget : Gadget {
        let testGadget = Gadget()
        testGadget.name = "Test Gadget"
        testGadget.cost = 10000
        testGadget.numActive = 0
        return testGadget
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Designate this class as the tableView delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier(gadgetList[indexPath.row])
        let cell = tableView.dequeueReusableCellWithIdentifier("GadgetStoreTableViewCell") as! GadgetStoreTableViewCell
        
        cell.gadget = self.testGadget
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gadgetStoreToGadgetDescriptionSegue", sender: self.testGadget)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gadgetDescriptionVC = segue.destinationViewController as! GadgetDescriptionViewController
        gadgetDescriptionVC.gadget = sender as? Gadget
    }
    
    

}