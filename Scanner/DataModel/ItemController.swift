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
    
    func addItem(context: NSManagedObjectContext,data: ItemData) -> Bool {
        let existingItem = findAllItems(context: context,filterString: nil,ownerName: nil,categoryName: nil,grid: false)
        if existingItem.contains(where: { $0.name == data.name }) {
            return false // Name is already in use
        }
        
        let item = Item(context: context)
        item.id = UUID()  // Assign a unique ID
        item.name = data.name
        item.price = data.price
        item.quantity = Int32(data.quantity)
        item.status = data.status.rawValue
        item.imageURL = data.imageURL
        item.category = data.category
        item.owner = data.owner
        item.updatedAt = Date()
        save(context: context)
        return true
    }
    
    func findAllItems(context: NSManagedObjectContext,filterString:String?,ownerName:String?,categoryName:String?,grid:Bool) -> [Item]{
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var predicates: [NSPredicate] = []
        
        if let filterString = filterString, !filterString.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", filterString))
        }
        
        if let ownerName = ownerName, !ownerName.isEmpty {
            predicates.append(NSPredicate(format: "owner.name == %@", ownerName))
        }
        
        if let categoryName = categoryName, !categoryName.isEmpty {
            predicates.append(NSPredicate(format: "category.name == %@", categoryName))
        }
        
        if grid == true{
            predicates.append(NSPredicate(format: "status == available"))
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
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
    
    func findItemById(context: NSManagedObjectContext,withId id: UUID) -> Item? {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let item = try context.fetch(fetchRequest)
            return item.first
        } catch {
            print("Failed to fetch item: \(error)")
            return nil
        }
    }
    
    func updateItem(context: NSManagedObjectContext,item:Item,itemData: ItemData) {
        item.category = itemData.category
        item.imageURL = itemData.imageURL
        item.name = itemData.name
        item.owner = itemData.owner
        item.price = itemData.price
        item.quantity = Int32(itemData.quantity)
        item.status = item.status
        item.updatedAt = Date()
        save(context: context)
    }
    
    func updateTransactionItemQuantity(context: NSManagedObjectContext, item: Item, quantity: Int ) {
        item.quantity = item.quantity - Int32(quantity)
        
        save(context: context)
    }
    
    func deleteItem(context: NSManagedObjectContext,item: Item) {
        context.delete(item)
        save(context: context)
    }
}
