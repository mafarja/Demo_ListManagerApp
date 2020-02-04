//
//  FHServiceMock.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/14/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class FHServiceMock: FHService {
  
  
  var data: [String: Any]?
  
  func getLists() {
    
  }
  
  func addList() {
    
  }
  
  func getTasks(list_id: String) {
    
  }
  
  func addTask(list_id: String) {
    
  }
  
  func sync(user_id: String?, lastSync: Date?, lists: [[String : Any]], completion: @escaping (Data?, Error?) -> Void) {
    
    guard var dataDict = self.data,
      var remoteLists = (dataDict["lists"] as? [[String: Any]]),
      var remoteTasks = (dataDict["tasks"] as? [[String: Any]])
    else {
      return completion(nil, NSError(domain: "Error", code: 0, userInfo: nil))
    }
    
    
    remoteLists.append(contentsOf: lists)
    
    dataDict["lists"] = remoteLists
    dataDict["tasks"] = remoteTasks
    
    
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: []) else {
      
      
      
      completion(nil, NSError(domain: "Error: Serialization of http post params failed", code: 0, userInfo: nil))
      return
    }
    
    completion(jsonData, nil)
  }
  
  
}
