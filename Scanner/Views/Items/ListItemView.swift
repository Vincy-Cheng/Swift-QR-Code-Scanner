//
//  ListItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import SwiftUI
import CoreData

struct ListItemView: View {
    @StateObject private var itemController = ItemController()
    @State private var isSheetPresented = false
    
    @State private var items: [Item] = [];
    
    // Define the grid layout
    let gridLayout = [
        GridItem(.flexible(),spacing: 5),
        GridItem(.flexible(),spacing: 5),
        GridItem(.flexible(),spacing: 5)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                LazyHGrid(rows: gridLayout, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            // Handle button tap here
                            print(item)
                        }) {
                            Text(item.name!)
                                .foregroundColor(.black)
                                .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                                .background(Color.white)
                                .cornerRadius(10)  // Add some rounding to the corners
                        }
                        .padding(10)  // Add some padding around the button
                    }
                    
                    Button(action: {
                        // Handle button tap here
                        isSheetPresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                            .background(Color.white)
                            .cornerRadius(10)
                        
                    }.sheet(isPresented: $isSheetPresented) {
                        // The content of the sheet goes here
                        CreateItemView(isPresented: $isSheetPresented)
                    }
                }
                .padding(.horizontal,10)
            }
        }
    }
    
    private func fetchItem(context: NSManagedObjectContext) {
        let context = itemController
            .container.viewContext
        items = itemController.findAllItems(context: context)
        print(items)
    }
}

#Preview {
    ListItemView()
}
