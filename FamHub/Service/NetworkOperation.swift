//
//  NetworkOperation.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/7/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class NetworkOperation: NetworkService {
  
  
  static var session = URLSession(configuration: .default)
  
  init() {
    
  }
  
  func sendHttpGetRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    NetworkOperation.session.dataTask(with: url) {
      (data, response, error) in
      guard let data = data,
        error == nil else {
          completion(nil, error)
          return
      }
      completion(data, nil)
    }.resume()
  }
  
  func sendHttpPostRequest(url: URL, params: [String: Any], completion: @escaping (Data?, Error?) -> Void) {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
      completion(nil, NSError(domain: "Error: Serialization of http post params failed", code: 0, userInfo: nil))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "Post"
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    NetworkOperation.session.dataTask(with: request) {
      (data, response, error) in
      guard let data = data,
        error == nil else {
        completion(nil, error)
        return
      }
      completion(data, nil)
    }.resume()
  }
}
