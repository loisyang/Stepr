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
        
        NotificationCenter.default.addObserver(self, selector: #selector(GadgetStoreViewController.updateTableData), name: NSNotification.Name(rawValue: "refreshGadgetStore"), object: nil)
        
        self.updateTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableData() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.gadgetModel.numberOfGadgetsAvailable()
        return 1 + self.gadgetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PointsInWalletTableViewCell") as! PointsInWalletTableViewCell
            cell.pointsInWallet = DashboardModel().getPointsInWallet()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GadgetStoreTableViewCell") as! GadgetStoreTableViewCell
            cell.gadget = self.gadgetList[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if indexPath.row > 0 {
            let gadget = self.gadgetList[indexPath.row - 1]
            if gadget.isUnlocked() {
                self.performSegue(withIdentifier: "gadgetStoreToGadgetDescriptionSegue", sender: gadget)
            }
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gadgetDescriptionVC = segue.destination as! GadgetDescriptionViewController
        gadgetDescriptionVC.gadget = sender as? Gadget
    }
    
    
    
}
