//
//  TransactionController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/9/24.
//

import Foundation
import CoreData


class TransactionController: DataController{
    
    func addTransaction(context: NSManagedObjectContext,payment:String,paid: Double, items:[Item]) -> Bool {
        let transaction = Transaction(context: context)
        
        transaction.id = UUID()
        transaction.payment = payment
        transaction.paid = paid
        transaction.createdAt = Date()
        
        // Create a dictionary to count the quantity of each item
        var itemQuantities: [Item: Int] = [:]
        for item in items {
            itemQuantities[item, default: 0] += 1
        }
        // Create TransactionItem objects for each item
        for (item, quantity) in itemQuantities {
            let transactionItem = TransactionItem(context: context)
            transactionItem.id = UUID()
            transactionItem.name = item.name
            transactionItem.price = item.price
            transactionItem.quantity = Int32(quantity) // Set the quantity
            
            // Associate the TransactionItem with the Transaction
            transactionItem.transaction = transaction
        }
        save(context: context)
        return true
    }
    
    func findAllTransaction(context: NSManagedObjectContext)-> [Transaction]{
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        request.relationshipKeyPathsForPrefetching = ["transactionItems"]
        
        do {
            let result = try context.fetch(request)
            return result
            
        } catch {
            print("Failed to fetch owners: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func deleteTransaction(context: NSManagedObjectContext, transaction: Transaction){
        context.delete(transaction)
        save(context: context)
    }
}