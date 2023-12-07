//
//  ListPurchaseLogView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/3/23.
//

import SwiftUI
import CoreData

func formattedDate(from date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy - HH:mm:ss"
    return dateFormatter.string(from: date)
}

struct ListPurchaseLogView:View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var purchaseLogs: FetchedResults<PurchaseLog>
 
    @State private var selectedOption: String = "Owners"

    var body: some View{
        if selectedOption == "Owners" {
            let products = Array(purchaseLogs)
            let parsedProducts:[Product]? = parsePurchaseLogs(purchaseLogs: products)
            if let parsedProducts{
                let owners = Array(Set(parsedProducts.map { $0.owner })).sorted()
                
                List(owners, id: \.self) { owner in
                    NavigationLink(destination: GroupedProductsView(owner: owner, products: parsedProducts.filter { $0.owner == owner })) {
                        Text("Owner: \(owner)")
                    }
                }
                .navigationBarTitle(selectedOption)
                .toolbar {
                    Menu {
                        Section("Group by") {
                            Button("Date") { selectedOption = "Date"  }
                            Button("Owner") { selectedOption = "Owners" }
                        }
                    } label: {
                        Label("Menu", systemImage: "square.grid.3x3.topleft.filled")
                    }}
            } else {
                Text("Error parsing products")
            }
        }
        else{
            List{
                ForEach(purchaseLogs.sorted(by: { $0.createdAt! > $1.createdAt! }), id: \.self) {
                    log in
                    if let createdAt = log.createdAt {
                        NavigationLink(destination: PurchaseLogView(purchaseLog: log)) {
                            Text("Purchase Log: \(formattedDate(from: createdAt))")
                        }
                        
                    }
                    
                }
            }.toolbar {
                Menu {
                    Section("Group by") {
                        Button("Date") { selectedOption = "Date"  }
                        Button("Owner") { selectedOption = "Owners" }
                    }
                } label: {
                    Label("Menu", systemImage: "square.grid.3x3.topleft.filled")
                }}
        }
        
        
    }
    
    
}
struct ListPurchaseLogView_Previews:PreviewProvider{
    static var previews: some View{
        ListPurchaseLogView()
    }
}
