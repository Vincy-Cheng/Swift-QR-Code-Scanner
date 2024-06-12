//
//  OwnerController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/5/24.
//

import Foundation
import CoreData

class OwnerController: DataController{
    
    func addOwner(context: NSManagedObjectContext,name:String) -> Bool{
        // Check if the name is already in use
        let existingOwner = findAllOwners(context: context)
        if existingOwner.contains(where: { $0.name == name }) {
            return false // Name is already in use
        }
        
        // If the name is not in use, add the owner
        let owner = Owner(context: context)
        owner.id = UUID()  // Assign a unique ID
        owner.name = name
        owner.updatedAt = Date()
        save(context: context)
        
        return true // Owner added successfully
    }
    
    func preInsertOwner(context: NSManagedObjectContext,name:String) -> Owner{
        let owner = Owner(context: context)
        owner.id = UUID()  // Assign a unique ID
        owner.name = name
        owner.updatedAt = Date()
        save(context: context)
        
        return owner // Owner added successfully
    }
    
    func findAllOwners(context: NSManagedObjectContext) -> [Owner] {
        let request: NSFetchRequest<Owner> = Owner.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch owners: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateOwnerName(context: NSManagedObjectContext,owner: Owner, newName: String) {
        owner.name = newName
        owner.updatedAt = Date()
        
        // Save changes to Core Data
        save(context: context)
    }
    
    func deleteOwner(context: NSManagedObjectContext,_ owner: Owner) {
        context.delete(owner)
        save(context: context)
    }
}
