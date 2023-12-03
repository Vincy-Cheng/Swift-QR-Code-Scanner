//
//  DataController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/3/23.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "PurchaseLog")
    
    init(){
        container.loadPersistentStores{
            desc, error in
            if let error = error{
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context:NSManagedObjectContext){
        do{
            try context.save()
            print("Data saved!")
        } catch {
            print("We could not save the data")
        }
    }
    
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
