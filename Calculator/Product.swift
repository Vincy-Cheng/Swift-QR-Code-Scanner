//
//  Product.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/28/23.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
  let id: UUID
  let value: Double
  let name: String
  let owner: String

  // Manually create Product
  init(id: UUID = UUID(), value: Double, name: String, owner: String) {
    self.id = id
    self.value = value
    self.name = name
    self.owner = owner
  }

  // CodingKeys to map properties to keys in JSON
  enum CodingKeys: String, CodingKey {
    case value, name, owner
  }

  // Custom initializer for decoding
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.value = try container.decode(Double.self, forKey: .value)
    self.name = try container.decode(String.self, forKey: .name)
    self.owner = try container.decode(String.self, forKey: .owner)

    // Assign a default UUID since it's not present in the JSON
    self.id = UUID()
  }

  // Manual implementation of Encodable
  enum EncodingKeys: String, CodingKey {
    case id, value, name, owner
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: EncodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(value, forKey: .value)
    try container.encode(name, forKey: .name)
    try container.encode(owner, forKey: .owner)
  }
}

// Decode JSON string
func parseJSON(from string: String) -> [Product]? {
  guard let jsonData = string.data(using: .utf8) else { return nil }
  do {
    let decoder = JSONDecoder()
    let products = try decoder.decode([Product].self, from: jsonData)

    return products
  } catch {
    print("Error decoding JSON: \(error)")
    return nil
  }
}

// Encode JSON string
func stringifyObject(products: [Product]) -> String? {
  do {
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(products)
    let json = String(data: jsonData, encoding: String.Encoding.utf8)
    return json
  } catch {
    print("Error ： \(error)")
    return nil
  }
}

// Parse the encoded products into Product instance array
func parsePurchaseLogs(purchaseLogs: [PurchaseLog]) -> [Product]? {
  let stringifiedArray = purchaseLogs.map { $0.content }
  let productsArray = stringifiedArray.compactMap { parseJSON(from: $0!) }
  return productsArray.flatMap { $0 }
}
