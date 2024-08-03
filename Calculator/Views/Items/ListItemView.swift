//
//  ListItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/8/24.
//

import SwiftUI

struct ItemGroup {
  var items: [Item]
  var ownerName: String
}

struct ListItemView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @StateObject private var itemController = ItemController()
  @State private var itemGroups: [ItemGroup] = []

  @State private var isSheetPresented = false

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        List {
          ForEach(itemGroups, id: \.ownerName) { group in
            Section(header: Text(group.ownerName).font(.headline)) {
              ForEach(group.items, id: \.self) { item in
                NavigationLink {
                  // destination view to navigation to
                  ItemView(isPresented: $isSheetPresented, item: item)
                } label: {
                  Text(item.name!)
                }
              }
            }
          }
        }

      }.navigationTitle("Manage Item")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
              isSheetPresented = true
            }, label: {
              Image(systemName: "plus")
            }).sheet(isPresented: $isSheetPresented) {
              CreateItemView(isPresented: $isSheetPresented)
            }
          }
        }
        .onAppear {
          groupItemByOwner()
        }
    }
  }

  private func fetchItem() -> [Item] {
    let items = itemController.findAllItems(
      context: managedObjectContext,
      filterString: nil,
      ownerName: nil,
      categoryName: nil,
      grid: false
    )
    return items
  }

  private func groupItemByOwner() {
    let items = fetchItem()

    var groupedItems: [ItemGroup] = []

    // Iterate through the items
    for item in items {
      // Get the owner for the current item
      guard let owner = item.owner else {
        continue // Skip this item if it has no owner
      }

      if let groupIndex = groupedItems.firstIndex(where: { $0.ownerName == owner.name! }) {
        groupedItems[groupIndex].items.append(item)
      } else {
        groupedItems.append(ItemGroup(items: [item], ownerName: owner.name!))
      }
    }
    itemGroups = groupedItems
  }
}

#Preview {
  ListItemView()
}
