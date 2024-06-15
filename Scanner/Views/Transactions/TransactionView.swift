//
//  TransactionView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/10/24.
//

import SwiftUI

struct TransactionView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var transaction:Transaction
    @State private var isAlert = false
    
    var body: some View {
        VStack{
            if let createdAt = transaction.createdAt {
                Text("Time: \(formattedDate(from: createdAt))")
                    .font(.headline)
            }
            
            ForEach(transaction.transactionItems?.allObjects as? [TransactionItem] ?? [], id: \.self){item in
                HStack{
                    Text("x\(item.quantity)  \(item.name!)")
                    
                    Spacer()
                    
                    Text("$\(Int(item.price) * Int(item.quantity))")
                }
                
            }.padding(.vertical)
            
            Divider()
            
            HStack{
                Spacer()
                HStack{
                    Text("Total")
                    Text("$\(addUp())")
                }
            }
            
            Button("Delete Item", role: .destructive) {
                isAlert = true
            }.padding()
            Spacer()
        }
        .alert(isPresented: $isAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Confirm to delete transaction"),
                primaryButton: .destructive(Text("Delete")) {
                    TransactionController().deleteTransaction(context: managedObjectContext, transaction: transaction)
                    isAlert = false
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .frame(alignment:.topLeading)
            .padding()
    }
    
    private func addUp()-> Int{
        var total = 0
        let items = transaction.transactionItems?.allObjects as? [TransactionItem] ?? []
        for item in items{
            total += Int(item.price) * Int(item.quantity)
        }
        
        return total
    }
}
