//
//  ListCategoryView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/8/24.
//

import CoreData
import SwiftUI

struct ListCategoryView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var categoryController = CategoryController()

  @State private var categories: [Category] = []
  @State private var selectedCategory: Category? // Track selected category for editing
  @State private var inputText = ""

  @State private var isShowingAlert = false
  @State private var isShowDeleteConfirmation = false // Separate state for delete confirmation alert
  @State private var isPresentingEditView = false

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        HStack {
          TextField("Enter category name", text: $inputText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading)

          Button(action: {
            if !inputText.isEmpty {
              if categoryController.addCategory(
                context: managedObjectContext,
                name: inputText.trimmingCharacters(in: .whitespacesAndNewlines)
              ) {
                fetchCategory(context: managedObjectContext) // Fetch owners if adding owner was successful
                inputText = "" // Clear the text field
              } else {
                isShowingAlert = true // Show alert if name is already in use
              }
            }
          }, label: {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 20, height: 20)
              .padding(.trailing)
          }).padding(.trailing) // Add trailing padding
        }
        .padding(.bottom) // Add bottom padding

        List {
          ForEach(categories, id: \.self) { category in
            HStack {
              Text(category.name ?? "Unknown")

              Spacer()

              Button(action: {
                selectedCategory = category // Set the selected owner for editing
                isPresentingEditView = true

              }, label: {
                Image(systemName: "info.circle")
                  .foregroundColor(.blue)
              }).padding(.leading)
            }
          }.onDelete(perform: { indexSet in
            let selected = indexSet.map { categories[$0] }
            deleteCategory(selected[0])
          })
        }
        .listStyle(PlainListStyle())
      }

      .onAppear {
        fetchCategory(context: managedObjectContext)
      }
      .alert(isPresented: $isShowingAlert) {
        Alert(
          title: Text("Name Already in Use"),
          message: Text("Please enter a unique name."),
          dismissButton: .default(Text("OK"))
        )
      }
      .sheet(item: $selectedCategory, onDismiss: {
        fetchCategory(context: managedObjectContext)
      }) { selectedCategory in
        EditCategoryView(category: selectedCategory, isPresented: $isPresentingEditView)
      }
      .navigationBarTitle("Manage Category")
    }
  }

  private func fetchCategory(context: NSManagedObjectContext) {
    categories = categoryController.findAllCategories(context: context)
  }

  private func deleteCategory(_ category: Category) {
    categoryController.deleteCategory(context: managedObjectContext, category)
    fetchCategory(context: managedObjectContext)

    isShowDeleteConfirmation = false
  }
}

#Preview {
  ListCategoryView()
}
