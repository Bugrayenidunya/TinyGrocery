//
//  HomeViewModel.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 23.11.2020.
//

import Foundation

class HomeViewModel {
  
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
  
  /// Checkout shopping basket
  
  // TODO: - Do This: Implement checkout function
  
}
