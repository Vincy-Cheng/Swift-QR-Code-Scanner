//
//  ItemController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import Foundation
import CoreData

enum ItemStatus: String {
    case available
    case archive
}

struct ItemData {
    let name: String
    let price: Double
    let quantity: Int
    let status: ItemStatus
    let imageURL: String
    let category: Category
    let owner: Owner
}

class ItemController: DataController{
    
    func addItem(context: NSManagedObjectContext,data: ItemData) {
        let item = Item(context: context)
        item.id = UUID()  // Assign a unique ID
        item.name = data.name
        item.price = data.price
        item.quantity = Int32(data.quantity)
        item.status = data.status.rawValue
        item.imageURL = data.imageURL
        item.category = data.category
        item.owner = data.owner
        save(context: context)
    }
    func findAllItems(context: NSManagedObjectContext) -> [Item]{
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Set the relationships to be fetched with the main entity
        request.relationshipKeyPathsForPrefetching = ["owner", "category"]
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Failed to fetch owners: \(error.localizedDescription)")
            return []
        }
    }
    
    //    func updateOwnerName(owner: Owner, newName: String) {
    //        owner.name = newName
    //
    //        // Save changes to Core Data
    //        let context = container.viewContext
    //        save(context: context)
    //    }
    //
    //    func deleteOwner(_ owner: Owner, context: NSManagedObjectContext) {
    //        context.delete(owner)
    //        save(context: context)
    //    }
}
