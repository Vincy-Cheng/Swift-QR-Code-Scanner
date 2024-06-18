//
//  ItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/8/24.
//

import SwiftUI
import PhotosUI

struct ItemView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var item: Item
    
    @Binding var isPresented: Bool
    @State private var isPresentCategoryCreate = false
    @State private var isCameraPresented = false
    @State private var isImageChange = false
    @State private var isAlert = false
    @State private var isEditAlert = false
    
    @State private var name = ""
    @State private var price = 0
    @State private var quantity = 0
    @State private var status = "available"
    @State private var category: Category? = nil
    @State private var owner: Owner? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var categories: [Category] = []
    
    @FocusState private var isFocused: Bool
    
    private let options = ["available", "archive"];
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    Section(header: Text("Name")) {
                        TextField("Enter the name", text: $name)
                    }
                    Section(header: Text("Price")) {
                        TextField("Enter the price", value: $price, formatter: formatter())
                            .keyboardType(.numberPad)
                    }
                    Section(header: Text("Quantity")) {
                        TextField("Enter the quantity", value: $quantity, formatter: formatter())
                            .keyboardType(.numberPad)
                    }
                    Section(header: Text("Status")) {
                        Picker("Select the status", selection: $status) {
                            ForEach(options, id: \.self) {
                                Text($0).tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    categoryPickerSection
                    ownerPickerSection
                    
                    Section(header: Text("Image")) {
                        
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
                    
                    deleteButton
                }
                .background(Color.white.onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                .navigationBarTitle("Edit item")
                .navigationBarItems(trailing: saveButton)
            }
            .onAppear {
                initializeFields()
            }
            .alert(isPresented: $isAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Confirm to delete item"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteItem()
                        isAlert = false
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(isPresented: $isEditAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text("Please fill all the fields"),
                    dismissButton: .default(Text("OK")) {
                        isEditAlert = false // Dismiss the alert when OK is tapped
                    }
                )
            }
            
            EditItemImageView(selectedImage: $selectedImage, selectedItem: $selectedItem, isCameraPresented: $isCameraPresented,isImageChange: $isImageChange)
            Spacer()
            }
            
    }
    
    private func initializeFields() {
        name = item.name ?? ""
        price = Int(item.price)
        quantity = Int(item.quantity)
        status = item.status ?? "available"
        category = item.category
        owner = item.owner
        selectedImage = loadImageFromRelativePath(relativePath: item.imageURL ?? "")
        categories = CategoryController().findAllCategories(context: managedObjectContext)
    }
    
    private var categoryPickerSection: some View {
        Section(header: categoryHeader) {
            Picker("Select the category", selection: $category) {
                ForEach(categories, id: \.self) {
                    Text($0.name ?? "").tag($0 as Category?)
                }
            }
            .pickerStyle(.menu)
        }
        .onAppear {
            if category == nil{
                category = categories.first
            }
        }
    }
    
    private var categoryHeader: some View {
        HStack {
            Text("Category")
            Spacer()
            Button("Add category") {
                isPresentCategoryCreate = true
            }
            .font(.caption)
            .sheet(isPresented: $isPresentCategoryCreate,onDismiss: {
                categories = CategoryController().findAllCategories(context: managedObjectContext)
            }) {
                CreateCategoryView()
            }
        }
    }
    
    private var ownerPickerSection: some View {
        Section(header: Text("Owner")) {
            Picker("Select the owner", selection: $owner) {
                ForEach(fetchOwners(), id: \.self) {
                    Text($0.name ?? "").tag($0 as Owner?)
                }
            }
            .pickerStyle(.menu)
        }
        .onAppear {
            if owner == nil{
                owner = fetchOwners().first
            }
        }
    }
    
    private var deleteButton: some View {
        Button("Delete Item", role: .destructive) {
            isAlert = true
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            updateItem()
            if isAlert == false{
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func fetchOwners() -> [Owner] {
        OwnerController().findAllOwners(context: managedObjectContext)
    }
    
    private func updateItem() {
        if name.isEmpty || category == nil || owner == nil{
            isEditAlert = true
            return
        }
        
        var imageURL = item.imageURL ?? ""
        if isImageChange, let selectedImage = selectedImage {
            let imagePath = saveImageToDocumentsDirectory(image: selectedImage)!
//            let oldFilePath = getFileURL(path: imageURL)
//            deleteFile(at: oldFilePath!)
            imageURL = imagePath
        }
        guard let updatedStatus = ItemStatus(rawValue: status) else {
            fatalError("Invalid status value")
        }
       
        let itemData = ItemData(
            name: name,
            price: Double(price),
            quantity: quantity,
            status: updatedStatus,
            imageURL: imageURL,
            category: category!,
            owner: owner!
        )
        ItemController().updateItem(context: managedObjectContext, item: item, itemData: itemData)
    }
    
    private func deleteItem() {
        guard let relativePath = item.imageURL else { return }
        let fileURL = getFileURL(path: relativePath)
        
        ItemController().deleteItem(context: managedObjectContext, item: item)
        deleteFile(at: fileURL!)
    }
    
    private func getFileURL(path:String) -> URL?{
        let relativePath = path
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get Documents directory")
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(relativePath)
        return fileURL
    }
    
    private func deleteFile(at url: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
            print("File deleted successfully: \(url)")
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }
}

struct EditItemImageView: View {
    @Binding var selectedImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var isCameraPresented: Bool
    @Binding var isImageChange: Bool
    
    var body: some View {
        HStack {
            PhotosPicker(selection:$selectedItem, matching: .any(of: [.images])){
                Text("Select photo")
            }
            Button(action: {
                isCameraPresented = true
            }){
                Text("Take Photo").foregroundStyle(.blue)
            }
            .padding()
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isCameraPresented) {
                CameraView(selectedImage: $selectedImage, isPresented: $isCameraPresented, isCaptured: $isImageChange)
            }
            
            
        }.onChange(of: selectedItem){
            _ in
            Task{
                if let selectedItem,
                   let data = try? await selectedItem.loadTransferable(type: Data.self){
                    if let image = UIImage(data:data){
                        selectedImage = image
                        isImageChange = true
                    }
                }
                
                selectedItem = nil
            }
            
        }
    }
}
