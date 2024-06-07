//
//  CreateCategoryView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/7/24.
//

import SwiftUI
import CoreData

struct CreateCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var categoryController = CategoryController()
    @State private var name = ""
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Name")) {
                    TextField("Enter the name", text: $name)
                }
            }.navigationBarTitle("Add Category")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Create") {
                        let context = categoryController.container.viewContext
                        categoryController.addCategory(context:context , name: name)
                        presentationMode.wrappedValue.dismiss()
                    }
                )
        }
       
    }
}
