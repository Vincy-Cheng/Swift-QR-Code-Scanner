//
//  ListTransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/9/24.
//

import SwiftUI
import CoreData

struct ListTransactionView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @StateObject private var transactionController = TransactionController()
    @StateObject private var itemController = ItemController()
    @State private var transactions: [Transaction] = []
    var body: some View {
        VStack{
            List{
                ForEach(transactions, id: \.self) { transaction in
                    NavigationLink{
                        TransactionView(transaction: transaction)
                    } label: {
                        Text(formattedDate(from: transaction.createdAt!))
                    }
//                    Text(formattedDate(from: transaction.createdAt!))
                    //                    Section(header: Text(group.ownerName).font(.headline)){
                    //                        ForEach(group.items, id: \.self) {item in
                    //                            NavigationLink {
                    //                                // destination view to navigation to
                    //                                ItemView(item: item,isPresented: $isSheetPresented)
                    //                            } label: {
                    //                                Text(item.name!)
                    //                            }
                    //                        }
                    //                    }
                }
            }.navigationTitle("Records")
        }.onAppear{
            fetchTransactions()
        }
        
    }
    
    private func fetchTransactions() {
        let transaction = transactionController.findAllTransaction(context: managedObjectContext)
        transactions = transaction
        print(transaction)
    }
    
    
}

func unWrapItems(transactions: [Transaction],context:NSManagedObjectContext) -> [Item]{
    let items:[Item] = []
//    for transaction in transactions {
//        guard let itemQuantities = transaction.itemQuantities as? [Item] else {
//            return []
//        }
        
//        for itemQuantity in itemQuantities {
////            let item = ItemController().findItemById(context: context, withId: itemQuantity)
//        }
//    }
    return items
}

#Preview {
    ListTransactionView()
}
