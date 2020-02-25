//
//  FamHubAPI.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/14/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class FamHubAPI: NSObject, FHService {
 
  var service: NetworkService!
  
  init(service: NetworkService) {
    super.init()
    self.service = service
  }
  
  convenience override init() {
    let service = NetworkOperation()
    self.init(service: service)
  }
  
  func getLists() {
    
  }
  
  func addList() {
    
  }
  
  func getTasks(list_id: String) {
    
  }
  
  func addTask(list_id: String) {
    
  }
  
  func sync(user_id: String?, lastSync: Date?, lists: [[String: Any]], completion: @escaping (Data?, Error?) -> Void) {
    
    
    var params = [
      "user_id": user_id,
      "lists": lists
      ] as [String : Any]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    if let lastSync = lastSync {
      params["lastSync"] = dateFormatter.string(from: lastSync)
    }
  
    let  url = URL(string: glb_Domain + "/sync")!
     
    self.service.sendHttpPostRequest(url: url, params: params as [String : Any], completion: {
      (data, error) in
      guard let data = data,
        error == nil else {
          completion(nil, error)
          return
      }
      completion(data, nil)
    })
  }
}
