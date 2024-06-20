//
//  GridItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import CoreData
import Foundation
import SwiftUI

struct GridItemView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var itemController = ItemController()
  @StateObject private var ownerController = OwnerController()
  @StateObject private var categoryController = CategoryController()
  @State private var isSheetPresented = false

  @Binding var selectedItems: [Item]
  @Binding var needRefresh: Bool

  @State private var items: [Item] = []
  @State private var name: String = ""
  @State private var ownerName: String = ""
  @State private var categoryName: String = ""

  // Define the grid layout
  let gridLayout = [
    GridItem(.flexible(), spacing: 10),
    GridItem(.flexible(), spacing: 10)
  ]

  var body: some View {
    VStack {
      filterView

      TextField("", text: $name, prompt: Text("Enter the item name").foregroundColor(.gray))
        .foregroundStyle(.gray)
        .padding(.horizontal)
        .onChange(of: name) { _ in
          fetchItem()
        }.padding(.vertical, 5)

      scrollView
    }.background(Color(uiColor: UIColor(red: 173 / 255, green: 194 / 255, blue: 223 / 255, alpha: 1)))
  }

  private var filterView: some View {
    return Section {
      let owners = ownerController.findAllOwners(context: managedObjectContext)
      let categories = categoryController.findAllCategories(context: managedObjectContext)
      HStack {
        HStack {
          Text("Owner:")
          Picker("Select owner", selection: $ownerName) {
            Text("All").tag("")
            ForEach(owners, id: \.name) { owner in
              Text(owner.name ?? "").tag(owner.name ?? "")
            }
          }
          .foregroundStyle(primaryColor)
          .pickerStyle(.menu)
        }
        HStack {
          Text("Category:")
          Picker("Select category", selection: $categoryName) {
            Text("All").tag("")
            ForEach(categories, id: \.name) { category in
              Text(category.name ?? "").tag(category.name ?? "")
            }
          }
          .foregroundStyle(primaryColor)
          .pickerStyle(.menu)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }.onChange(of: ownerName) { _ in
      fetchItem()
    }
    .padding(.horizontal)
    .padding(.vertical, 5)
  }

  private var scrollView: some View {
    return GeometryReader { geometry in
      ScrollView(.horizontal) {
        LazyHGrid(rows: gridLayout, spacing: 10) {
          ForEach(items, id: \.self) { item in

            let uiImage = loadImageFromRelativePath(relativePath: item.imageURL!)
            ZStack {
              if uiImage != nil {
                Image(uiImage: uiImage!)
                  .resizable()
                  .scaledToFill()
                  .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                  .clipped()
                  .cornerRadius(20)
                  .padding(10)
                  .opacity(0.6)
                  .saturation(item.quantity <= 0 ? 0 : 1)
              } else {
                Image("Image-Not-Found")
                  .resizable()
                  .scaledToFill()
                  .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                  .clipped()
                  .cornerRadius(20)
                  .saturation(item.quantity <= 0 ? 0 : 1)
                  .padding(10)
              }

              VStack {
                Text(item.name!)
                  .foregroundColor(uiImage == nil ? primaryColor : Color.white)
                  .font(.system(size: 18)) // Adjust font size as needed
                  .fontWeight(.bold)
                  .padding(.top, 20)
                  .frame(maxWidth: geometry.size.width / 3)
                Spacer()

                Text("$\(Int(item.price))")
                  .foregroundColor(uiImage == nil ? primaryColor : Color.white)
                  .font(.system(size: 18)) // Adjust font size as needed
                  .fontWeight(.bold)
                  .frame(maxWidth: geometry.size.width / 3)
                HStack {
                  Button(action: {
                    // Minus action
                    let index = selectedItems.firstIndex(of: item)
                    if index != nil {
                      selectedItems.remove(at: index!)
                    }

                  }) {
                    Image(systemName: "minus.circle.fill")
                      .foregroundColor(primaryColor)
                      .font(.system(size: 28))
                  }
                  .padding([.leading], 20) // Adjust the trailing padding
                  .disabled(item.quantity <= 0)

                  Spacer()
                  if uiImage != nil {
                    Text(String(
                      countItem(targetItem: item)
                    )) // Display the number here, replace "5" with your actual number
                    .foregroundColor(.white)
                    .font(.system(size: 18)) // Adjust font size as needed
                    .fontWeight(.bold)
                    .padding([.bottom], 10)
                  } else {
                    Text(String(
                      countItem(targetItem: item)
                    )) // Display the number here, replace "5" with your actual number
                    .foregroundColor(.black)
                    .font(.system(size: 18)) // Adjust font size as needed
                    .fontWeight(.bold)
                    .padding([.bottom], 10)
                  }

                  Spacer()

                  Button(action: {
                    if countItem(targetItem: item) < item.quantity {
                      selectedItems.append(item)
                    }

                  }) {
                    Image(systemName: "plus.circle.fill")
                      .foregroundColor(primaryColor)
                      .font(.system(size: 28))
                  }
                  .padding([.trailing], 20)
                  .disabled(item.quantity <= 0)
                }
                .padding(.bottom, 20)
              }
            }
          }

          Button(action: {
            // Handle button tap here
            isSheetPresented = true
          }) {
            Image(systemName: "plus")
              .foregroundColor(primaryColor)
              .font(.system(size: 48))
              .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
              .background(Color.white)
              .cornerRadius(20)

          }.sheet(isPresented: $isSheetPresented, onDismiss: {
            fetchItem()
          }) {
            // The content of the sheet goes here
            CreateItemView(isPresented: $isSheetPresented)
          }.padding(10)
        }
        .padding(.bottom, 20)

      }.onAppear {
        fetchItem()
      }
      .onChange(of: needRefresh) { _ in
        fetchItem()
      }
      .onChange(of: ownerName) { _ in
        fetchItem()
      }
      .onChange(of: categoryName) { _ in
        fetchItem()
      }
    }
  }

  private func fetchItem() {
    let filter = name.isEmpty ? "" : name
    let owner = ownerName.isEmpty ? "" : ownerName
    let category = categoryName.isEmpty ? "" : categoryName

    items = itemController.findAllItems(
      context: managedObjectContext,
      filterString: filter,
      ownerName: owner,
      categoryName: category,
      grid: true
    )
  }

  private func countItem(targetItem: Item) -> Int {
    var count = 0
    for item in selectedItems {
      if targetItem.id == item.id {
        count += 1
      }
    }
    return count
  }
}

func loadImageFromRelativePath(relativePath: String) -> UIImage? {
  // Get the URL for the Documents directory
  guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    print("Failed to get Documents directory")
    return nil
  }

  // Construct the absolute file URL by appending the relative path
  let fileURL = documentsDirectory.appendingPathComponent(relativePath)

  do {
    // Read the image data from the file URL
    let imageData = try Data(contentsOf: fileURL)

    // Create UIImage from the image data
    if let image = UIImage(data: imageData) {
      return image
    } else {
      print("Failed to create UIImage from image data")
      return nil
    }
  } catch {
    print("Error loading image: \(error.localizedDescription)")
    return nil
  }
}
