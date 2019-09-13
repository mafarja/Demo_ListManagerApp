//
//  NetworkOperation.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/7/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class NetworkOperation {
 
  var queryURL: URL
  static var session = URLSession(configuration: .default)
  
  init(url: URL) {
    self.queryURL = url
  }
  
  func sendHttpGetRequest(_ success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
    
    let task = NetworkOperation.session.dataTask(with: queryURL) {
      (data, response, error) in
      
      if let error = error {
        failure(error)
      }
      
      guard let httpResponse = response as? HTTPURLResponse
         else {
          failure(NSError(domain: "Unknown network error.", code: 0, userInfo: nil))
          return
      }
      
      if let data = data,
        httpResponse.statusCode == 200 {
        success(data)
      } else {
        failure(NSError(domain: "Network error", code: httpResponse.statusCode, userInfo: nil))
      }
    }.resume()
  }
  
  func sendHttpPostRequest(_ params: [String: Any]? = [:], success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
    
    let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    var request = URLRequest(url: queryURL)
    request.httpMethod = "Post"
    request.httpBody = jsonData
    
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request) {
      (data, response, error) in
      
      if let error = error {
        failure(error)
      }
      
      guard let httpResponse = response as? HTTPURLResponse
        else {
          failure(NSError(domain: "Unknown network error.", code: 0, userInfo: nil))
          return
      }
      
      if let data = data,
        httpResponse.statusCode == 200 {
        success(data)
      } else {
        failure(NSError(domain: "Network error", code: httpResponse.statusCode, userInfo: nil))
      }
    }.resume()
  }
}
