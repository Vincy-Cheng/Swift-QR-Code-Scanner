//
//  ItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/8/24.
//

import PhotosUI
import SwiftUI

struct ItemView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode

  @Binding var isPresented: Bool
  @State var item: Item?

  @State private var isAlert = false
  @State private var alertContent = ""

  var body: some View {
    NavigationStack {
      ItemFormView(
        title: "Manage Item",
        mode: Mode.edit,
        item: $item,
        isAlert: $isAlert,
        alertContent: $alertContent,
        callback: updateItem,
        deleteItem: deleteItem
      )
    }
  }

  private func updateItem(newItem: ItemData, selectedImage: UIImage?) -> Bool {
    if newItem.name.isEmpty || newItem.category == nil || newItem.owner == nil {
      isAlert = true
      alertContent = "Name / category / owner cannot be null"
      return false
    }

    var imageURL = newItem.imageURL

    let oldImage = loadImageFromRelativePath(relativePath: (item?.imageURL)!)

    if oldImage != nil && selectedImage != nil {
      let isImageMatch = areImagesEqual(oldImage, selectedImage)
      if !isImageMatch {
        // Delete the old one and save the new one
        deleteFile(at: getFileURL(path: (item?.imageURL)!)!)
        imageURL = saveImageToDocumentsDirectory(image: selectedImage!) ?? ""
      }
    }

    let itemData = ItemData(
      name: newItem.name,
      price: Double(newItem.price),
      quantity: newItem.quantity,
      status: newItem.status,
      imageURL: imageURL,
      category: newItem.category!,
      owner: newItem.owner!
    )
    ItemController().updateItem(context: managedObjectContext, item: item!, itemData: itemData)

    return true
  }

  private func deleteItem() {
    guard let relativePath = item!.imageURL else { return }
    let fileURL = getFileURL(path: relativePath)
    ItemController().deleteItem(context: managedObjectContext, item: item!)
    deleteFile(at: fileURL!)
  }
}
