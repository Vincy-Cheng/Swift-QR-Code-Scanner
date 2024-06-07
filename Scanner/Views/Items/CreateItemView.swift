//
//  CreateItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//

import SwiftUI
import PhotosUI
import CoreData

struct CreateItemView: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var itemController = ItemController()
    
    @Binding var isPresented: Bool // Binding to dismiss the view
    @State var isPresentCategoryCreate: Bool = false // Binding to dismiss the view
    @State private var name = ""
    @State private var price = 0
    @State private var quantity = 0
    @State private var status = "available"
    
    @State private var category: Category? = nil;
    
    @State private var owner: Owner? = nil;
    
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isCameraPresented = false
    
    @FocusState private var isFocused: Bool
    
    let options = ["available", "archive"]

    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter the name", text: $name)
                }
                Section(header: Text("Price")) {
                    TextField("Enter the price", value: $price, formatter: formatter).keyboardType(.numberPad)
                }
                Section(header: Text("Quantity")) {
                    TextField("Enter the quantity", value: $quantity, formatter: formatter).keyboardType(.numberPad)
                }
                Section(header: Text("Status")) {
                    Picker("Select the status", selection: $status) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                let categories = CategoryController().findAllCategories(context: managedObjectContext)
                
                Section(header: HStack{
                    Text("Category")
                    Button(action: {
                        isPresentCategoryCreate = true
                    }, label: {
                        Text("Add category").font(.caption)
                    }).sheet(isPresented: $isPresentCategoryCreate){
                        CreateCategoryView()
                    }
                }) {
                    Picker("Select the category", selection: Binding(
                        get: { category ?? categories.first }, // Unwrap the optional selectedOwner
                        set: { category = $0 }
                    )) {
                        ForEach(categories, id: \.self) {
                            Text($0.name!)
                        }
                        
                    }
                    .pickerStyle(.menu)
                }.onAppear {
                    // Set the default selection once owners becomes available
                    category = categories.first // Assuming owners is an array of Owner objects
                }
                
                let owners = OwnerController().findAllOwners(context: managedObjectContext)
    
                Section(header: Text("Owner")) {
                    Picker("Select the owner", selection: Binding(
                        get: { owner ?? owners.first }, // Unwrap the optional selectedOwner
                        set: { owner = $0 }
                    )) {
                        ForEach(owners, id: \.self) {
                            Text($0.name!)
                        }
                    }
                    .pickerStyle(.menu)
                }.onAppear {
                    // Set the default selection once owners becomes available
                    owner = owners.first // Assuming owners is an array of Owner objects
                }
                
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Select Photo")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
                
                Button(action: {
                    isCameraPresented = true
                }) {
                    Text("Take Photo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isCameraPresented) {
                    CameraView(selectedImage: $selectedImage, isPresented: $isCameraPresented)
                }
                
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("No image selected")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                
            }
            .background( // <-- add background
                Color.white // <-- this is also a view
                    .onTapGesture { // <-- add tap gesture to it
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .navigationBarTitle("Add item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                    
                },
                trailing: Button("Create") {
                    create(selectedImage!)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
        
    }
    
    private func create(_ image: UIImage) {
        let context = managedObjectContext
        
        if image != nil{
            print("calling function1")
            if let imagePath = saveImageToDocumentsDirectory(image: image) {
                let data = ItemData(name: name, price: Double(price), quantity: quantity, status: ItemStatus(rawValue: status) ?? ItemStatus.available, imageURL: imagePath, category: category!, owner: owner!)
                itemController.addItem(context: context, data: data)
            }
        }else{
            
            print("calling function")
            let data = ItemData(name: name, price: Double(price), quantity: quantity, status: ItemStatus(rawValue: status) ?? ItemStatus.available, imageURL: "", category: category!, owner: owner!)
            itemController.addItem(context: context, data: data)
            
        }
    }
    
}



func saveImageToDocumentsDirectory(image: UIImage) -> String? {
    guard let data = image.jpegData(compressionQuality: 1.0) else {
        return nil
    }
    
    let filename = UUID().uuidString + ".jpg"
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    
    do {
        try data.write(to: fileURL)
        return fileURL.path
    } catch {
        print("Error saving image: \(error)")
        return nil
    }
}


