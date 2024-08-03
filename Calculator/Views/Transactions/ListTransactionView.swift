//
//  ListTransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/9/24.
//

import CoreData
import SwiftUI

struct ListTransactionView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var transactionController = TransactionController()
  @StateObject private var itemController = ItemController()
  @State private var transactions: [Transaction] = []
  var body: some View {
    NavigationStack {
      List {
        ForEach(transactions, id: \.self) { transaction in
          NavigationLink {
            TransactionView(transaction: transaction)
          } label: {
            Text(formattedDate(from: transaction.createdAt!))
          }
        }.onDelete(perform: deleteTransaction)
      }.navigationTitle(Text("Records").foregroundColor(Color.mark))
    }.onAppear {
      fetchTransactions()
    }.toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          GroupedTransactionView()
        } label: {
          HStack(alignment: .center) {
            Text("Next")
            Image(systemName: "chevron.right.2")
          }.foregroundColor(
            Color.mark
          )
        }
      }
    }
  }

  private func fetchTransactions() {
    let transaction = transactionController.findAllTransaction(
      context: managedObjectContext,
      startDate: Date(),
      endDate: Date(),
      groupingMethod: "all"
    )
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
