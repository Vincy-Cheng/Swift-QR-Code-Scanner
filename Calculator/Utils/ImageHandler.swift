//
//  ImageHandler.swift
//  Calculator
//
//  Created by Wing Lam Cheng on 6/20/24.
//

import Foundation
import PhotosUI

func areImagesEqual(_ image1: UIImage?, _ image2: UIImage?) -> Bool {
  guard let data1 = image1?.pngData(), let data2 = image2?.pngData() else {
    return false
  }
  return data1 == data2
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

func getFileURL(path: String) -> URL? {
  let relativePath = path
  guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  else {
    print("Failed to get Documents directory")
    return nil
  }
  let fileURL = documentsDirectory.appendingPathComponent(relativePath)
  return fileURL
}

func deleteFile(at url: URL) {
  let fileManager = FileManager.default

  do {
    try fileManager.removeItem(at: url)
    print("File deleted successfully: \(url)")
  } catch {
    print("Error deleting file: \(error.localizedDescription)")
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
