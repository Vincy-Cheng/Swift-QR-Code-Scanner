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
        NavigationStack{
            
            List{
                ForEach(transactions, id: \.self) { transaction in
                    NavigationLink{
                        TransactionView(transaction: transaction)
                    } label: {
                        Text(formattedDate(from: transaction.createdAt!))
                    }
                }.onDelete(perform: deleteTransaction)
                
//                .onDelete(perform: { indexSet in
//                    let selectedTransaction = indexSet.map { transactions[$0] }
//                    transactionController.deleteTransaction(context: managedObjectContext, transaction: selectedTransaction.first!)
//                    fetchTransactions()
//                })
            }.navigationTitle("Records")
            
            
            HStack(alignment: .lastTextBaseline){
                Text("Daily Record").foregroundColor(primaryColor).font(.title)
                Spacer()
                NavigationLink{
                    GroupedTransactionView()
                } label: {
                    Label(
                        title: { Text("Next").foregroundColor(primaryColor) },
                        icon: { Image(systemName: "chevron.right.2").foregroundColor(primaryColor) }
                    )
                }
            }.padding()
                .frame(alignment: .bottom)
            
        }.onAppear{
            fetchTransactions()
        }
        
    }
    
    private func fetchTransactions() {
        let transaction = transactionController.findAllTransaction(context: managedObjectContext,date: Date(),groupingMethod: "all")
        transactions = transaction
        print(transaction)
    }
    
    private func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            transactionController.deleteTransaction(context: managedObjectContext, transaction: transaction)
        }
        fetchTransactions()
    }
}

#Preview {
    ListTransactionView()
}
