//
//  PurchaseLogView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/7/23.
//

import SwiftUI
import CoreData

struct PurchaseLogView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @State private var showAlert = false
    
    let purchaseLog: PurchaseLog // Your array of Product objects
    
    var body: some View{
        VStack(alignment: .leading){
            if let createdAt = purchaseLog.createdAt {
                Text("Time: \(formattedDate(from: createdAt))")
                    .font(.headline)
                    .padding()
            }
            let products = Array(arrayLiteral: purchaseLog)
            let parsedProducts:[Product]? = parsePurchaseLogs(purchaseLogs: products)
            
            if let parsedProducts{
                let totalValue = parsedProducts.reduce(0) { $0 + $1.value }
                
                Text("Total Value: \(String(format: "%.2f", totalValue))") // Displaying the formatted total value
                    .font(.headline)
                    .padding()
                
                Button(action:{
                    showAlert = true
                }){
                    Text("Delete record")
                        .padding()
                        .foregroundStyle(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }.alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Confirm to delete this record"),
                        primaryButton: .destructive(Text("Delete")) {
                            // Call the deletion function here
                            managedObjectContext.delete(purchaseLog)
                            DataController().save(context: managedObjectContext)
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                List {
                    let groupedProducts = Dictionary(grouping: parsedProducts) { $0.name }
                    
                    ForEach(groupedProducts.sorted(by: { $0.key < $1.key }), id: \.key) { name, product in
                        
                        let index = groupedProducts.keys.sorted().firstIndex(of: name) ?? 0
                        
                        HStack(alignment: .center){
                            Text("Item \(index + 1)")
                            
                            VStack(alignment: .leading) {
                                Text("Product Name: \(product[0].name)")
                                Text("Owner: \(product[0].owner)")
                                Text("Price: HKD$\(String(format: "%.2f", product[0].value))")
                            }
                            
                            Spacer()
                            
                            Text("x \(product.count)")
                        }
                    }
                }
            } else {
                Text("Error parsing products")
            }
        }.navigationBarTitle("Purchase Log",displayMode: .inline)
    }
}
