//
//  ListItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import SwiftUI
import CoreData
import Foundation

struct GridItemView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @StateObject private var itemController = ItemController()
    @State private var isSheetPresented = false
    
    @Binding var selectedItems: [Item]
    
    @State private var items: [Item] = []
    
    // Define the grid layout
    let gridLayout = [
        GridItem(.flexible(),spacing: 10),
        GridItem(.flexible(),spacing: 10),
        //        GridItem(.flexible(),spacing: 5)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                LazyHGrid(rows: gridLayout, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        
                        let uiImage = loadImageFromRelativePath(relativePath: item.imageURL!)
                        ZStack {
                            if uiImage != nil {
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                    .clipped()
                                    .cornerRadius(20)
                                    .padding(10)
                                    .opacity(0.6)
                            } else {
                                Image("Image-Not-Found")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                    .clipped()
                                    .cornerRadius(20)
                                    .padding(10)
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    
                                    Button(action: {
                                        // Minus action
                                        let index = selectedItems.firstIndex(of: item)
                                        if(index != nil){
                                            selectedItems.remove(at: index!)
                                        }
                                        
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(Color(uiColor: UIColor(red: 120/255, green: 108/255, blue: 255/255, alpha: 1)))
                                            .font(.system(size: 24))
                                    }
                                    .padding([.leading, .bottom], 10) // Adjust the trailing padding
                                    
                                    Spacer()
                                    if uiImage != nil{
                                        Text(String(countItem(targetItem: item))) // Display the number here, replace "5" with your actual number
                                                .foregroundColor(.white)
                                                .font(.system(size: 18)) // Adjust font size as needed
                                                .fontWeight(.bold)
                                                .padding([.bottom], 10)
                                    }else{
                                        Text(String(countItem(targetItem: item))) // Display the number here, replace "5" with your actual number
                                                .foregroundColor(.black)
                                                .font(.system(size: 18)) // Adjust font size as needed
                                                .fontWeight(.bold)
                                                .padding([.bottom], 10)
                                    }
                                    
                                        
                                    Spacer()
                                    
                                    Button(action: {
                                        selectedItems.append(item)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Color(uiColor: UIColor(red: 120/255, green: 108/255, blue: 255/255, alpha: 1)))
                                            .font(.system(size: 24))
                                    }
                                    .padding([.trailing, .bottom], 10)
                                    
                                }
                                .padding(10)
                            }
                        }
                    }
                    
                    Button(action: {
                        // Handle button tap here
                        isSheetPresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color(uiColor: UIColor(red: 120/255, green: 108/255, blue: 255/255, alpha: 1)))
                            .font(.system(size: 48))
                            .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                            .background(Color.white)
                            .cornerRadius(20)
                        
                        
                    }.sheet(isPresented: $isSheetPresented,onDismiss: {
                        fetchItem()
                    }) {
                        // The content of the sheet goes here
                        CreateItemView(isPresented: $isSheetPresented)
                    }.padding(10)
                }
                .padding(.bottom, 20)
                
            }.onAppear{
                fetchItem()
            }
        }.background(Color(uiColor: UIColor(red: 173/255, green: 194/255, blue: 223/255, alpha: 1)))
 
    }
    
    private func fetchItem() {
        items = itemController.findAllItems(context: managedObjectContext)
    }
    
    private func countItem(targetItem:Item) -> Int{
        var count = 0
        for item in selectedItems {
            if targetItem.id == item.id  {
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

