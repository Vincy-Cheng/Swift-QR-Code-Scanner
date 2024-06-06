//
//  CategoryController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import Foundation
import CoreData


class CategoryController: DataController{
    
    func addCategory(context: NSManagedObjectContext,name:String) {
        let category = Category(context: context)
        category.id = UUID()  // Assign a unique ID
        category.name = name
        save(context: context)
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

}
