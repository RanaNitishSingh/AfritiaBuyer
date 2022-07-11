//
//  MyAPIClient.swift
//  Afritia
//
//  Created by Ranjit Mahto on 02/11/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import UIKit

enum Result {
  case success
  case failure(Error)
}


final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
      // private
    }
    
    private lazy var baseURL: URL = {
      guard let url = URL(string:"your server url for commit payment") else {
        fatalError("Invalid URL")
      }
      return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
      // 1
      let url = baseURL.appendingPathComponent("charge")
      // 2
      let params: [String: Any] = [
        "token": token.tokenId,
        "amount": amount,
        "currency": UserManager.getCurrencyType,
        "description": "product description"
      ]
      // 3
      AF.request(url, method: .post, parameters: params)
        .validate(statusCode: 200..<300)
        .responseString { response in
          switch response.result {
          case .success:
            completion(Result.success)
          case .failure(let error):
            completion(Result.failure(error))
          }
      }
    }
}



