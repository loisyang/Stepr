//
//  History.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class History: NSManagedObject {

    class func getAllHistory() -> [History]{
        let app = (UIApplication.shared.delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.fetch(request)
        } catch _ {
            results = nil
        }
        if results != nil && results!.count > 0 {
            print("hey")
            return results as! [History]
        } else {
            return []
        }

    }
// Insert code here to add functionality to your managed object subclass

}
