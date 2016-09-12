//
//  Gadget.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import CoreData


class Gadget: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func unlock(){
        //deduct cost from total points
        //set numActive from 0 to to one
        //update coredata
    }
    func addOne(){
        //increment numActive for one
        //update coredata
    }
    
    class func calculatePoints(moc: NSManagedObjectContext, newSteps: Int) -> Double {
        //body
        var bonus:Int = 0
        
        var gadgetsFetch = NSFetchRequest(entityName: "Gadget")
        
        do {
            let gadgets = try moc.executeFetchRequest(gadgetsFetch) as! [Gadget]
            for gadget in gadgets {
                bonus += gadget.bonus as! Int
            }
            return Double(newSteps * bonus)
        } catch {
            fatalError("Failed to fetch gadgets: \(error)")
        }
    }


}
