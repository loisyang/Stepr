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
    var gadgetList : [Gadget] = [] {
        didSet {
            self.updateTableData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Designate this class as the tableView delegate and data source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "Gadget")
        
        let sortDescriptor = NSSortDescriptor(key: "unlockLevel", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            self.gadgetList = results as! [Gadget]
        } else {
            self.gadgetList = []
        }
        
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
        return self.gadgetList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier(gadgetList[indexPath.row])
        let cell = tableView.dequeueReusableCellWithIdentifier("GadgetStoreTableViewCell") as! GadgetStoreTableViewCell
        
        cell.gadget = self.gadgetList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gadgetStoreToGadgetDescriptionSegue", sender: self.gadgetList[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gadgetDescriptionVC = segue.destinationViewController as! GadgetDescriptionViewController
        gadgetDescriptionVC.gadget = sender as? Gadget
    }
    
    

}
