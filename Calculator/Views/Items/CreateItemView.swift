//
//  CreateItemView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/6/24.
//
import CoreData
import PhotosUI
import SwiftUI

struct CreateItemView: View {
  @Environment(\.managedObjectContext) var managedObjectContext

  @StateObject private var itemController = ItemController()

  @Binding var isPresented: Bool

  @State private var isAlert = false
  @State private var alertContent = ""

  var body: some View {
    NavigationStack {
      ItemFormView(
        title: "Add Item",
        mode: Mode.create,
        item: .constant(nil),
        isAlert: $isAlert,
        alertContent: $alertContent,
        callback: createItem
      )
    }
  }

  private func createItem(item: ItemData, selectedImage: UIImage?) -> Bool {
    guard let category = item.category, let owner = item.owner else {
      isAlert = true
      alertContent = "Please fill all the fields"
      return false
    }
    if item.name.isEmpty {
      isAlert = true
      alertContent = "Please fill all the fields"
      return false
    }

    guard let status = ItemStatus(rawValue: item.status.rawValue) else {
      fatalError("Invalid status value")
    }

    let imageURL: String
    if let selectedImage = selectedImage {
      imageURL = saveImageToDocumentsDirectory(image: selectedImage) ?? ""
    } else {
      imageURL = ""
    }

    let itemData = ItemData(
      name: item.name,
      price: Double(item.price),
      quantity: item.quantity,
      status: status,
      imageURL: imageURL,
      category: category,
      owner: owner
    )
    let isCreated = itemController.addItem(context: managedObjectContext, data: itemData)

    if isCreated {
      return true
    } else {
      isAlert = true
      alertContent = "Please create with an unique name"
      return false
    }
  }
}

enum Mode {
  case create
  case edit
}

struct ItemFormView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode
  @State var title: String
  @State var mode: Mode
  @Binding var item: Item?
  @Binding var isAlert: Bool
  @Binding var alertContent: String

  // Computed property for the button label
  var buttonLabel: String {
    switch mode {
    case .create:
      return "Create"
    case .edit:
      return "Save"
    }
  }

  var callback: (_ item: ItemData, _ selectedImage: UIImage?) -> Bool

  var deleteItem: (() -> Void)?

  @State private var targetItem: ItemData = .init(
    name: "",
    price: 0,
    quantity: 0,
    status: ItemStatus.available,
    imageURL: "",
    category: nil,
    owner: nil
  )

  private let options = [ItemStatus.available, ItemStatus.archive]

  @State private var categories: [Category] = []
  @State private var owners: [Owner] = []
  @State private var isPresentCategoryCreate = false

  @State private var selectedImage: UIImage?
  @State private var selectedItem: PhotosPickerItem?
  @State private var isCameraPresented = false

  @State private var isDeleteAlert = false

  var body: some View {
    VStack {
      Form {
        Section(header: Text("Name")) {
          TextField("Enter the name", text: $targetItem.name)
        }

        Section(header: Text("Price")) {
          TextField("Enter the price", value: $targetItem.price, formatter: formatter())
            .keyboardType(.numberPad)
        }
        Section(header: Text("Quantity")) {
          TextField("Enter the quantity", value: $targetItem.quantity, formatter: formatter())
            .keyboardType(.numberPad)
        }
        Section(header: Text("Status")) {
          Picker("Select the status", selection: $targetItem.status) {
            ForEach(options, id: \.self) {
              Text($0.rawValue).tag($0 as ItemStatus)
            }
          }
          .tint(primaryColor)
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

        // Delete item button, only available when mode = edit
        Button(action: {
          isAlert = true
          alertContent = "Confirm to delete?"
          isDeleteAlert = true
        }, label: {
          Text("Delete Item").foregroundStyle(.red)
        })
      }

      ItemImageView(
        selectedImage: $selectedImage,
        selectedItem: $selectedItem,
        isCameraPresented: $isCameraPresented
      )
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }.navigationBarTitle(title)
    .navigationBarItems(
      leading: Button("Cancel") {
        presentationMode.wrappedValue.dismiss()
      },
      trailing: Button(buttonLabel) {
        let result = callback(targetItem, selectedImage)

        if result {
          presentationMode.wrappedValue.dismiss()
        }
      }
    )
    .alert(isPresented: $isAlert) {
      if isDeleteAlert {
        Alert(
          title: Text("Warning"),
          message: Text(alertContent),
          primaryButton: .destructive(Text("Delete")) {
            deleteItem!()
            isAlert = false
            presentationMode.wrappedValue.dismiss()
          },
          secondaryButton: .cancel {
            isAlert = false
            isDeleteAlert = false
          }
        )
      } else {
        Alert(
          title: Text("Warning"),
          message: Text(alertContent),
          dismissButton: .cancel(Text("OK")) {
            isAlert = false // Dismiss the alert when OK is tapped
          }
        )
      }
    }
    .onAppear {
      categories = CategoryController().findAllCategories(context: managedObjectContext)

      owners = OwnerController().findAllOwners(context: managedObjectContext)

      if item != nil {
        targetItem.name = item!.name!
        targetItem.price = item!.price
        targetItem.quantity = Int(item!.quantity)
        targetItem.status = ItemStatus(rawValue: item!.status!) ?? ItemStatus.available
        targetItem.category = item!.category
        targetItem.owner = item!.owner
        selectedImage = loadImageFromRelativePath(relativePath: item!.imageURL ?? "")
      }

      // Set the default category and owner
      if targetItem.category == nil {
        targetItem.category = categories.first
      }

      if targetItem.owner == nil {
        targetItem.owner = owners.first
      }
    }
  }

  private var categoryPickerSection: some View {
    return Section(header: HStack {
      Text("Category")
      Spacer()
      Button("Add category") {
        isPresentCategoryCreate = true
      }
      .font(.caption)
      .foregroundStyle(primaryColor)
      .sheet(isPresented: $isPresentCategoryCreate, onDismiss: {
        categories = CategoryController().findAllCategories(context: managedObjectContext)
      }) {
        CreateCategoryView()
      }
    }) {
      Picker("Select the category", selection: $targetItem.category) {
        if categories.isEmpty {
          Text("No categories available").tag(nil as Category?)
        } else {
          ForEach(categories, id: \.self) {
            Text($0.name!).tag($0 as Category?)
          }
        }
      }
      .tint(primaryColor)
      .pickerStyle(.menu)
    }
  }

  private var ownerPickerSection: some View {
    return Section(header: Text("Owner")) {
      Picker("Select the owner", selection: $targetItem.owner) {
        if owners.isEmpty {
          Text("No owners available").tag(nil as Owner?)
        } else {
          ForEach(owners, id: \.self) {
            Text($0.name!).tag($0 as Owner?)
          }
        }
      }
      .tint(primaryColor)
      .pickerStyle(.menu)
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

struct ItemImageView: View {
  @Binding var selectedImage: UIImage?
  @Binding var selectedItem: PhotosPickerItem?
  @Binding var isCameraPresented: Bool

  var body: some View {
    HStack {
      PhotosPicker(selection: $selectedItem, matching: .any(of: [.images])) {
        Text("Select photo")
      }
      Button(action: {
        isCameraPresented = true
      }, label: {
        Text("Take Photo").foregroundStyle(.blue)
      })
      .padding()
      .foregroundColor(.white)
      .cornerRadius(10)
      .sheet(isPresented: $isCameraPresented) {
        CameraView(selectedImage: $selectedImage, isPresented: $isCameraPresented)
      }
    }.onChange(of: selectedItem) {
      _ in
      Task {
        if let selectedItem,
           let data = try? await selectedItem.loadTransferable(type: Data.self)
        {
          if let image = UIImage(data: data) {
            selectedImage = image
          }
        }

        selectedItem = nil
      }
    }
  }
}
