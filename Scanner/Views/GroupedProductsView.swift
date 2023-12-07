//
//  GroupedProductsView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 12/7/23.
//

import SwiftUI

struct GroupedProductsView: View {
    let owner: String // Selected owner name
    let products: [Product] // Your array of Product objects
    
    var body: some View {
        List {
            let groupedProducts = Dictionary(grouping: products) { $0.name }
            
            ForEach(groupedProducts.sorted(by: { $0.key < $1.key }), id: \.key) { name, product in
                Section{
                    Text("Product Name: \(product[0].name)")
                    Text("Price: HKD$\(String(format: "%.2f", product[0].value))")
                    Text("Quantity: \(product.count)")
                    Text("Total: HKD$\(String(format: "%.2f", product[0].value * Double(product.count)))")
                }
            }
        }
        .navigationBarTitle(owner,displayMode: .inline)
    }
}

