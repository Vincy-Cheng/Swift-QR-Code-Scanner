//
//  CreateItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import SwiftUI

struct CreateItemView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool // Binding to dismiss the view
    @State private var name = ""
    @State private var price = 0
    @State private var quantity = 0
    @State private var status = "available"
    @State private var category: Category? = nil;
    @State private var owner: Owner? = nil;
    
    let options = ["available", "archive"]
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter the name", text: $name)
                }
                Section(header: Text("Price")) {
                    TextField("Enter the price", value: $price, formatter: formatter)
                }
                Section(header: Text("Quantity")) {
                    TextField("Enter the quantity", value: $quantity, formatter: formatter)
                }
                Section(header: Text("Status")) {
                    Picker("Select the status", selection: $status) {
                                    ForEach(options, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                }
                let categories = CategoryController().findAllCategories(context: managedObjectContext)
                Section(header: Text("Category")) {
                    Picker("Select the category", selection: $category) {
                                    ForEach(categories, id: \.self) {
                                        Text($0.name!)
                                    }
                                }
                                .pickerStyle(.menu)
                }
                let owners = OwnerController().findAllOwners(context: managedObjectContext)
                Section(header: Text("Owner")) {
                    Picker("Select the owner", selection: $owner) {
                                    ForEach(owners, id: \.self) {
                                        Text($0.name!)
                                    }
                                    Text("New Category")
                                }
                                .pickerStyle(.menu)
                }
            }
            .navigationBarTitle("Add item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Create") {
                    
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func updateOwnerName() {
       
        
        isPresented = false // Dismiss the view
    }
}


