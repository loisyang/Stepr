//
//  GadgetsViewController.swift
//  Stepr
//
//  Created by Ziyun Zheng on 9/12/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit
import CoreData

class GadgetsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    func loadGadgets(){
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Gadget")
        
        do {
            let result = try context.executeFetchRequest(request)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        //populate the view with gadgets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
