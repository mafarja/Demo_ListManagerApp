//
//  ServiceMock.swift
//  FamHubTests
//
//  Created by Marcelo Farjalla on 9/19/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class NetworkServiceMock: NetworkService {
  
  
  var data: Data?
  
  init() {
    
  }
  
  func sendHttpGetRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    print("sendHttpGetRequest called with url \(url)")
    
    completion(data, nil)
  }
  
  func sendHttpPostRequest(url: URL, params: [String : Any], completion: @escaping (Data?, Error?) -> Void) {
    print("sendHttpPostRequest called with url \(url)")
    
    completion(data, nil)
  }
  
  
  
}
