//
//  OwnerController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/5/24.
//

import Foundation
import CoreData

class OwnerController: DataController{
    
    func addOwner(name:String,context: NSManagedObjectContext) -> Bool{
        // Check if the name is already in use
        let existingOwners = findAllOwners(context: context)
        if existingOwners.contains(where: { $0.name == name }) {
            return false // Name is already in use
        }
        
        // If the name is not in use, add the owner
        let owner = Owner(context: context)
        owner.id = UUID()  // Assign a unique ID
        owner.name = name
        save(context: context)
        
        return true // Owner added successfully
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
    
    func updateOwnerName(owner: Owner, newName: String) {
        owner.name = newName
        
        // Save changes to Core Data
        let context = container.viewContext
        save(context: context)
    }
    
    func deleteOwner(_ owner: Owner, context: NSManagedObjectContext) {
        context.delete(owner)
        save(context: context)
    }
}
