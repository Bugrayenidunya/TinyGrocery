//
//  Endpoint.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 22.11.2020.
//

import Foundation

// MARK: - Endpoints for Service

enum Endpoint {
  /// Endpoint for getting all grocery items
  case getItems
  /// Endpoint for checkout to shopping basket
  case checkout
  
  /// Schemes for each endpoint
  var scheme: String {
    switch self {
      case .getItems, .checkout:
        return "https"
    }
  }
  
  /// Hosts for each endpoint
  var host: String {
    switch self {
      case .getItems, .checkout:
        return "desolate-shelf-18786.herokuapp.com"
    }
  }
  
  /// Paths for each endpoint
  var path: String {
    switch self {
      case .getItems:
        return "/list"
      case .checkout:
        return "/checkout"
    }
  }
  
  /// Methods for each endpoint
  var method: String {
    switch self {
      case .getItems:
        return "GET"
      case .checkout:
        return "POST"
    }
  }
}
