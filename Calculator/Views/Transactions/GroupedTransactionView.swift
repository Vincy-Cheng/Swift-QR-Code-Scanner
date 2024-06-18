//
//  GroupedTransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/11/24.
//

import SwiftUI

struct TransactionItemGroup{
    let name: String
    var price: Double
    var quantity: Int
}

struct GroupedTransactionView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @StateObject private var transactionController = TransactionController()
    @State private var transactions: [Transaction] = []
    @State private var groupingMethod: String = ""
    let options = ["date","all"]
    
    @State private var groupedTransactionItems: [String: [TransactionItemGroup]] = [:]
    
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    Text("Records")
                        .font(.title)
                        .foregroundStyle(primaryColor)
                        .padding()
                    
                    Picker("Select the grouping method", selection: $groupingMethod) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: groupingMethod){
                        _ in
                        fetchTransactions()
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing)
                    
                    
                }
                if groupingMethod == "date" {
                    datePicker
                        .padding(.horizontal)
                }
                
                ScrollView {
                    ForEach(groupedTransactionItems.keys.sorted(), id: \.self) { ownerName in
                        VStack{
                            HStack{
                                Text(ownerName).font(.title)
                                Spacer()
                            }.padding(.bottom)
                            
                            ForEach(groupedTransactionItems[ownerName] ?? [], id: \.name) { itemGroup in
                                HStack{
                                    Text("x\(itemGroup.quantity)  \(itemGroup.name)")
                                    
                                    Spacer()
                                    
                                    Text("$\(Int(itemGroup.price))")
                                }
                            }
                            DashedLineView()
                            HStack{
                                Spacer()
                                Text("Total: $\(calculateTotal(for: ownerName))")
                                    .fontWeight(.bold)
                            }
                            Divider()
                        }
                        
                    }
                }.padding()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                if groupingMethod.isEmpty {
                    groupingMethod = options[0]
                }
            }
            .onAppear{
                fetchTransactions()
            }
        
    }
    
    private func calculateTotal(for ownerName: String) -> Int {
        let items = groupedTransactionItems[ownerName] ?? []
        let total = items.reduce(0) { $0 + Int($1.price) }
        return total
    }
    
    private var datePicker: some View {
        return DatePicker(
            "Select a date",
            selection: $selectedDate,
            in: ...Date.now,
            displayedComponents: .date
        )
        .onChange(of: selectedDate){
            _ in
            fetchTransactions()
        }
        .datePickerStyle(CompactDatePickerStyle()) // Adjust style as needed
        .labelsHidden() // Hide labels if you only want the picker
        
    }
    
    private func fetchTransactions() {
        let transaction = transactionController.findAllTransaction(context: managedObjectContext,date: selectedDate,groupingMethod: groupingMethod)
        transactions = transaction
        groupedTransactionItems = groupTransactionsByOwner(transactions: transactions)
    }
    
    private func groupTransactionsByOwner(transactions: [Transaction]) -> [String: [TransactionItemGroup]] {
        var groupedItems = [String: [TransactionItemGroup]]()
        
        for transaction in transactions {
            guard let transactionItems = transaction.transactionItems?.allObjects as? [TransactionItem] else { continue }
            
            for item in transactionItems {
                let ownerName = item.item?.owner?.name ?? "Unknown Owner"
                let itemName = item.item?.name ?? "Unknown Item"
                let itemPrice = item.price
                let itemQuantity = item.quantity
                
                if groupedItems[ownerName] == nil {
                    groupedItems[ownerName] = []
                }
                
                if let index = groupedItems[ownerName]?.firstIndex(where: { $0.name == itemName }) {
                    groupedItems[ownerName]?[index].quantity += Int(itemQuantity)
                    groupedItems[ownerName]?[index].price += itemPrice * Double(itemQuantity)
                } else {
                    let newItemGroup = TransactionItemGroup(name: itemName, price: itemPrice * Double(itemQuantity), quantity: Int(itemQuantity))
                    groupedItems[ownerName]?.append(newItemGroup)
                }
            }
        }
        return groupedItems
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy - HH:mm:ss"
    return dateFormatter.string(from: date)
}
