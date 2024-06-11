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
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var itemController = ItemController()
    
    @Binding var isPresented: Bool
    @State private var isPresentCategoryCreate = false
    @State private var name = ""
    @State private var price = 0
    @State private var quantity = 0
    @State private var status = "available"
    @State private var category: Category? = nil
    @State private var owner: Owner? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isCameraPresented = false
    @State private var isAlert = false
    @State private var alertContent = ""
    
    @FocusState private var isFocused: Bool
    
    private let options = ["available", "archive"]
    
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
                                Text($0)
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
                    
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .background(Color(uiColor: UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)))
                .navigationBarTitle("Add item")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Create") {
                        print("Create")
                        let isCreated = createItem()
                        if isCreated{
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                ).alert(isPresented: $isAlert){
                    Alert(
                        title: Text("Warning"),
                        message: Text(alertContent),
                        
                        dismissButton: .cancel(Text("OK")) {
                            isAlert = false // Dismiss the alert when OK is tapped
                        }
                    )
                }
                .onAppear{
                    checkPhotoLibraryPermission()
                    // Set default owner if owners is not empty
                    let owners = OwnerController().findAllOwners(context: managedObjectContext)
                    if !owners.isEmpty {
                        owner = owners.first
                    }
                    // Set default category if categories is not empty
                    let categories = CategoryController().findAllCategories(context: managedObjectContext)
                    if !categories.isEmpty {
                        category = categories.first
                    }
                }
                CreateItemImageView(selectedImage: $selectedImage, selectedItem: $selectedItem, isCameraPresented: $isCameraPresented)
                Spacer()
            }
            
            
        }
    }
    
    private var categoryPickerSection: some View {
        let categories = CategoryController().findAllCategories(context: managedObjectContext)
        
        return Section(header: HStack {
            Text("Category")
            Spacer()
            Button("Add category") {
                isPresentCategoryCreate = true
            }
            .font(.caption)
            .sheet(isPresented: $isPresentCategoryCreate) {
                CreateCategoryView()
            }
        }) {
            Picker("Select the category", selection: $category) {
                if categories.isEmpty {
                    Text("No categories available").tag(nil as Category?)
                } else {
                    ForEach(categories, id: \.self) {
                        Text($0.name!).tag($0 as Category?)
                    }
                }
            }
            .pickerStyle(.menu)
        }
        
    }
    
    private var ownerPickerSection: some View {
        let owners = OwnerController().findAllOwners(context: managedObjectContext)
        
        return Section(header: Text("Owner")) {
            Picker("Select the owner", selection: $owner) {
                if owners.isEmpty {
                    Text("No owners available").tag(nil as Owner?)
                } else {
                    ForEach(owners, id: \.self) {
                        Text($0.name!).tag($0 as Owner?)
                    }
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    private func createItem() -> Bool {
        guard let category = category, let owner = owner else {
            isAlert = true
            alertContent = "Please fill all the fields"
            return false }
        print("onclick")
        if name.isEmpty{
            isAlert = true
            alertContent = "Please fill all the fields"
            return false
        }
        
        let imagePath = selectedImage.flatMap { saveImageToDocumentsDirectory(image: $0) } ?? ""
        print("image \(imagePath)")
        let itemData = ItemData(
            name: name,
            price: Double(price),
            quantity: quantity,
            status: ItemStatus(rawValue: status) ?? .available,
            imageURL: imagePath,
            category: category,
            owner: owner
        )
        let isCreated = itemController.addItem(context: managedObjectContext, data: itemData)
        
        if isCreated {
            return true
        }else{
            isAlert = true
            alertContent = "Please create with an unique name"
            return false
        }
        
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    print("Photo library access granted.")
                } else {
                    print("Photo library access denied.")
                }
            }
        case .denied, .restricted:
            print("Photo library access denied.")
            // Show alert to guide user to Settings
            DispatchQueue.main.async {
                self.isAlert = true
                self.alertContent = "Photo library access is denied. Please enable it in Settings."
            }
        case .authorized, .limited:
            print("Photo library access granted.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
}

struct CreateItemImageView: View {
    @Binding var selectedImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var isCameraPresented: Bool
    @State private var isImageChange = false
    
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
            //                    .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isCameraPresented) {
                CameraView(selectedImage: $selectedImage, isPresented: $isCameraPresented, isCaptured: $isImageChange)
            }
            
            
        }.onChange(of: selectedImage){
            _ in
            Task{
                if let selectedItem,
                   let data = try? await selectedItem.loadTransferable(type: Data.self){
                    if let image = UIImage(data:data){
                        selectedImage = image
                    }
                }
                
                selectedItem = nil
            }
            
        }
    }
}

func formatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}

func saveImageToDocumentsDirectory(image: UIImage) -> String? {
    let filename = UUID().uuidString + ".jpg"
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
        print("Failed to convert UIImage to Data")
        return nil
    }
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Failed to get Documents directory")
        return nil
    }
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    do {
        try imageData.write(to: fileURL)
        print("Photo saved to: \(fileURL)")
        return fileURL.lastPathComponent
    } catch {
        print("Error saving photo: \(error.localizedDescription)")
        return nil
    }
}
