//
//  Product.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 23.11.2020.
//

import Foundation

// MARK: - Product Model

struct Product: Codable {
  // MARK: Properties
  let id: String
  let name: String
  let price: Double
  let currency: String
  let imageUrl: String
  let stock: Int
  
  // MARK: Codingkeys
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case price
    case currency
    case imageUrl
    case stock
  }
}
