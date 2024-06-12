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
        category.updatedAt = Date()
        save(context: context)
        return true
    }
    
    func preInsertCategory(context: NSManagedObjectContext,name:String) -> Category {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name as CVarArg)
        
        do {
            let existingCategory = try context.fetch(fetchRequest)
            
            print(existingCategory.isEmpty)
            
            if existingCategory.isEmpty{
                let category = Category(context: context)
                category.id = UUID()  // Assign a unique ID
                category.name = name
                category.updatedAt = Date()
                save(context: context)
                return category
            }else{
                return existingCategory.first!
            }
        } catch {
            let category = Category(context: context)
            category.id = UUID()  // Assign a unique ID
            category.name = name
            category.updatedAt = Date()
            save(context: context)
            return category
        }
  
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
    
    func findCategory(context: NSManagedObjectContext,name: String) -> Category? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name as CVarArg)
        
        do {
            let category = try context.fetch(fetchRequest)
            return category.first
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func updateCategoryName(context: NSManagedObjectContext,category: Category, newName: String) {
        category.name = newName
        category.updatedAt = Date()
        
        // Save changes to Core Data
        save(context: context)
    }
    
    func deleteCategory(context: NSManagedObjectContext,_ category: Category) {
        context.delete(category)
        save(context: context)
    }

}
