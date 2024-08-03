//
//  EditOwnerView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/5/24.
//

import CoreData
import SwiftUI

struct EditOwnerView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var owner: Owner
  @Binding var isPresented: Bool // Binding to dismiss the view
  @State private var newName = ""

  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Owner ID: \(String(describing: owner.id))")) {
          TextField("New Name", text: $newName)
        }
      }
      .navigationBarTitle("Edit Owner")
      .navigationBarItems(
        leading: Button("Cancel") {
          presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("Save") {
          updateOwnerName() // Call closure to handle updates
          presentationMode.wrappedValue.dismiss()
        }
      )
    }
  }

  private func updateOwnerName() {
    let ownerController = OwnerController()
    ownerController.updateOwnerName(context: managedObjectContext, owner: owner, newName: newName)
    isPresented = false // Dismiss the view
  }
}
