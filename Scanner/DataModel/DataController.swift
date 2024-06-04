//
//  DataController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/3/23.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "Container")
    
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
}
