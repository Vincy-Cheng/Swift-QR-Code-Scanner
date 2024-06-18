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
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject private var categoryController = CategoryController()
    @State private var name = ""
    @State private var isAlert = false
    @State private var alertContent = ""
    
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
                        if name.isEmpty{
                            isAlert = true
                            alertContent = "Cannot add empty string as category"
                        }else{
                            let created = categoryController.addCategory(context: managedObjectContext , name: name)
                            if created == true{
                                alertContent = ""
                                presentationMode.wrappedValue.dismiss()
                            }else{
                                isAlert = true
                                alertContent = "Category name is used"
                            }
                            
                        }
                        
                    }
                )
                .alert(isPresented: $isAlert){
                    Alert(
                        title: Text("Warning"),
                        message: Text(alertContent),
                        
                        dismissButton: .cancel(Text("OK")) {
                            isAlert = false // Dismiss the alert when OK is tapped
                            alertContent = ""
                        }
                    )
                }
        }
       
    }
}
