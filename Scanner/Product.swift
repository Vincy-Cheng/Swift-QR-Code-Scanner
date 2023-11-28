//
//  Product.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 11/28/23.
//

import Foundation

struct Product: Codable {
    let value: Double
    let name: String
    let owner: String
}

func parseJSON(from string: String) -> Product? {
    guard let jsonData = string.data(using: .utf8) else { return nil }
    do {
        let product = try JSONDecoder().decode(Product.self, from: jsonData)
        return product
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
