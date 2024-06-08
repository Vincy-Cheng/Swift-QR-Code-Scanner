//
//  CategoryController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import Foundation
import CoreData


class CategoryController: DataController{
    
    func addCategory(context: NSManagedObjectContext,name:String) -> Bool {
        let category = Category(context: context)
        
        let existingCategory = findAllCategories(context: context)
        if existingCategory.contains(where: { $0.name == name }) {
            return false // Name is already in use
        }
        
        category.id = UUID()  // Assign a unique ID
        category.name = name
        save(context: context)
        return true
    }
    
    func findAllCategories(context: NSManagedObjectContext) -> [Category]{
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(request)
            return result

        } catch {
            print("Failed to fetch owners: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateCategoryName(context: NSManagedObjectContext,category: Category, newName: String) {
        category.name = newName
        
        // Save changes to Core Data
        save(context: context)
    }
    
    func deleteCategory(context: NSManagedObjectContext,_ category: Category) {
        context.delete(category)
        save(context: context)
    }

}
