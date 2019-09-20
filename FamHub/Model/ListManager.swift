//
//  ListManager.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol ListManagerDelegate: AnyObject  {  // allows for viewControllers to refresh themselves
  func didAddList(list: List, sender: ListManager)
  func didAddTask(task: Task, sender: ListManager)
}

extension ListManagerDelegate {  // provides default implementation as to make methods optional
  func didAddList(list: List, sender: ListManager) {}
  func didAddTask(task: Task, sender: ListManager) {}
}

class ListManager: NSObject {
  var lists: [List]?
  static var delegate: ListManagerDelegate?  // needed to ensure only one delegated instance works across controllers
  var service: Service
  
  init(service: Service) {
    self.service = service
  }
  
  func add(list: List, completion: @escaping (Error?) -> Void) {
    let params = [
      "description": list.description,
      "name": list.name
    ]
    
    let  url = URL(string: glb_Domain + "/lists")!
    
    
    service.sendHttpPostRequest(url: url, params: params as [String : Any], completion: {
      (data, error) in
        
      guard let list = try? JSONDecoder().decode(List.self, from: data!) else {
        print("Error: Could not decode data")
        completion(error)
        return
      }
      
      if let delegate = ListManager.delegate {
        delegate.didAddList(list: list, sender: self)
      }
      completion(nil)
    })
  }
  
  func getLists(completion: @escaping ([List]?, Error?) -> Void) {
    if let lists = self.lists {
      completion(lists, nil)
      return
    }
    let  url = URL(string: glb_Domain + "/lists")!
    
    service.sendHttpGetRequest(url: url, completion: {
      (data, error) in
      guard let data = data,
        error == nil else {
          completion(nil, error ?? NSError(domain: "Error: Network error", code: 0 , userInfo: nil))
        return
      }
      do {
        self.lists = try JSONDecoder().decode(Array<List>.self, from: data)
        completion(self.lists, nil)
        return
      } catch let error {
        print(error)
        completion(nil, NSError(domain: error.localizedDescription, code: 0 , userInfo: nil))
      }
    })
  }
  
  func deleteList() {
    // to implement
  }
  
  func add(task: Task, completion: @escaping (Error?) -> Void) {
    let params = [
      "description": task.description,
      "list_id": task.list_id
    ]
    
    let  url = URL(string: glb_Domain + "/lists/" + task.list_id + "/tasks")!
    service.sendHttpPostRequest(url: url, params: params, completion: {
      (data, error) in
      
      let string = String(bytes: data!, encoding: .utf8)
      print(string)
      
      guard let data = data,
        error == nil else {
        
        completion(error!)
        return
      }
        
      guard let task = try? JSONDecoder().decode(Task.self, from: data) else {
        completion(NSError(domain: "Error: Could not decode object", code: 0, userInfo: nil))
        return
      }
      
      if let delegate = ListManager.delegate {
        delegate.didAddTask(task: task, sender: self)
      }
      completion(nil)
    })
  }
  
  func getTasks(list_id: String, completion: @escaping ([Task]?, Error?) -> Void) {
    let  url = URL(string: glb_Domain + "/lists/" + list_id + "/tasks")!
    service.sendHttpGetRequest(url: url, completion: {
      (data, error) in
      
      guard let data = data,
        error == nil else {
          completion(nil, error ?? NSError(domain: "Error: Network error", code: 0 , userInfo: nil))
          return
      }
      
      if let result = String(data: data, encoding: .utf8) {
        print(result)
      }
      
      do {
        let tasks = try JSONDecoder().decode(Array<Task>.self, from: data)
        completion(tasks, nil)
        return
      } catch let error {
        print(error)
        completion(nil, NSError(domain: error.localizedDescription, code: 0 , userInfo: nil))
      }
    })
  }
}
