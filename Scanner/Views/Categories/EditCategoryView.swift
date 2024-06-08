//
//  EditCategoryView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/8/24.
//

import SwiftUI
import CoreData

struct EditCategoryView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var category: Category
    @Binding var isPresented: Bool // Binding to dismiss the view
    @State private var newName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category ID: \(String(describing: category.id))")) {
                    TextField("New Name", text: $newName)
                }
            }
            .navigationBarTitle("Edit Category")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    updateCategoryName() // Call closure to handle updates
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
    }
    
    private func updateCategoryName() {
        let categoryController = CategoryController()
        categoryController.updateCategoryName(context: managedObjectContext ,category: category, newName: newName)
        isPresented = false // Dismiss the view
    }
}
