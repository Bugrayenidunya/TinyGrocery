//
//  HomeViewModel.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 23.11.2020.
//

import Foundation

class HomeViewModel {
  
  /// Shopping Basket
  var shoppingBasket: [Product] = []
  /// Store only uniqe value from basket, for show on the basket's badge
  var uniqueProducts: Set<String> = []
  /// Count every object in shopping basket
  var countOfEachProduct: [String:Int] = [:]
  
  /// Fetch all grocery products from API
  func fetchAllProducts(completion: @escaping(Swift.Result <[Product], Error> ) -> Void ) {
    Service.request(endpoint: Endpoint.getProducts) { (result: Result <[Product], Error>) in
      switch result {
        case .success(let products):
          completion(Swift.Result.success(products))
        case .failure(let error):
          completion(Swift.Result.failure(error))
      }
    }
  }
  
  /// Count single product in shopping basket
  func countProductInBasket(with id: String) -> Int {
    // Collect each product's id and count frequency for the badge count
    countOfEachProduct = self.shoppingBasket.reduce(into: [:]) { $0[$1.id, default: 0] += 1 }
    if countOfEachProduct[id] == nil {
      return 0
    }
    return countOfEachProduct[id]!
  }
  
  // Checkout shopping basket
  
  // TODO: - Do This: Implement checkout function
  
}
