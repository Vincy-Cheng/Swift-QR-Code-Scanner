//
//  ListOwnerView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/3/24.
//

import CoreData
import SwiftUI

struct ListOwnerView: View {
  //    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var owners: FetchedResults<Owner>
  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var ownerController = OwnerController()

  @State private var owners: [Owner] = []
  @State private var selectedOwner: Owner? // Track selected owner for editing
  @State private var inputText = ""

  @State private var isShowingAlert = false
  @State private var isShowDeleteConfirmation = false // Separate state for delete confirmation alert
  @State private var isPresentingEditView = false

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        HStack {
          TextField("Enter owner name", text: $inputText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading)

          Button(action: {
            if !inputText.isEmpty {
              if ownerController.addOwner(
                context: managedObjectContext,
                name: inputText.trimmingCharacters(in: .whitespacesAndNewlines)
              ) {
                fetchOwners(context: managedObjectContext) // Fetch owners if adding owner was successful
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
          ForEach(owners, id: \.self) { owner in
            HStack {
              Text(owner.name ?? "Unknown")

              Spacer()

              Button(action: {
                selectedOwner = owner // Set the selected owner for editing
                isPresentingEditView = true
                print("edit")
              }, label: {
                Image(systemName: "info.circle")
                  .foregroundColor(.blue)
              }).padding(.leading)
            }
          }.onDelete(perform: { indexSet in
            let selectedUser = indexSet.map { owners[$0] }
            deleteOwners(selectedUser[0])
          })
        }
        .listStyle(PlainListStyle())
      }

      .onAppear {
        fetchOwners(context: managedObjectContext)
      }
      .alert(isPresented: $isShowingAlert) {
        Alert(
          title: Text("Name Already in Use"),
          message: Text("Please enter a unique name."),
          dismissButton: .default(Text("OK"))
        )
      }
      .sheet(item: $selectedOwner) { selectedOwner in
        EditOwnerView(owner: selectedOwner, isPresented: $isPresentingEditView)
      }

      .navigationBarTitle("Manage Owner")
    }
  }

  private func fetchOwners(context: NSManagedObjectContext) {
    owners = ownerController.findAllOwners(context: managedObjectContext)
  }

  private func deleteOwners(_ owner: Owner) {
    ownerController.deleteOwner(context: managedObjectContext, owner)
    fetchOwners(context: managedObjectContext)

    isShowDeleteConfirmation = false
  }
}
