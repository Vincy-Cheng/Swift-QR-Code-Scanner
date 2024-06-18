//
//  PurchaseLogController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/5/24.
//

import Foundation
import CoreData

class PurchaseLogController: DataController{
    
    func addLog(content:String,context: NSManagedObjectContext){
        let log = PurchaseLog(context: context)
        
        // Assign the value
        log.id = UUID()
        log.createdAt = Date()
        log.updatedAt = Date()
        log.content = content
        
        // Save the content into database
        save(context: context)
    }
    
    func editLog(log:PurchaseLog,content:String,context:NSManagedObjectContext){
        // Update value
        log.content = content
        
        save(context: context)
    }
    
    func deleteLog(object:NSManagedObject,context:NSManagedObjectContext){
        context.delete(object)
    }
    

}
