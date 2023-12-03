//
//  Product.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/28/23.
//

import Foundation

struct Product: Codable,Identifiable {
    let id: UUID
    let value: Double
    let name: String
    let owner: String
    
    // Custom initializer for decoding
        init(from decoder: Decoder) throws {
            // Create a container to access the JSON properties
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decode other properties (value, name, owner)
            value = try container.decode(Double.self, forKey: .value)
            name = try container.decode(String.self, forKey: .name)
            owner = try container.decode(String.self, forKey: .owner)
            
            // Assign a UUID during decoding
            id = UUID()
        }
        
        // CodingKeys to map properties to keys in JSON
        private enum CodingKeys: String, CodingKey {
            case value, name, owner
        }
}

func parseJSON(from string: String) -> Product? {
    guard let jsonData = string.data(using: .utf8) else { return nil }
    do {
        let decoder = JSONDecoder()
        let product = try decoder.decode(Product.self, from: jsonData)
        
        return product
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
