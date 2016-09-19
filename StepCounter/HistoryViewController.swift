//
//  HistoryViewController.swift
//  Stepr
//
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //let gadgetsModel = GadgetsModel()
    var historyList : [History] = [] {
        didSet {
            self.updateTableData()
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    func updateTableData() {
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "History")
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            self.historyList = results as! [History]
        } else {
            self.historyList = []
        }
        self.updateTableData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier(gadgetList[indexPath.row])
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        cell.histroy = self.historyList[indexPath.row]
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
