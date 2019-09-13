//
//  ListManager.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol ListManagerDelegate: AnyObject  {
  func didAddList(list: List, sender: ListManager)
  func didAddTask(task: Task, sender: ListManager)
}

// provides default implementation as to make methods optional
extension ListManagerDelegate {
  func didAddList(list: List, sender: ListManager) {}
  func didAddTask(task: Task, sender: ListManager) {}
}

class ListManager: NSObject {
  
  static var lists: [List]?
  static var delegate: ListManagerDelegate?
  
  override init() {
    
  }
  
  func createList(name: String, completion: @escaping (Error?) -> Void) {
    let params = [
      "description": "Take the trash out",
      "name": name
    ]
    
    let  url = URL(string: glb_Domain + "/lists")!
    let networkOperation = NetworkOperation(url: url)
    
    networkOperation.sendHttpPostRequest(params,
      success:
      { (data) in
        if let result = String(data: data, encoding: .utf8) {
          print(result)
          
        }
        
        guard let list = try? JSONDecoder().decode(List.self, from: data) else {
          print("Error: Could not decode data")
          return
        }
        
        if let delegate = ListManager.delegate {
          delegate.didAddList(list: list, sender: self)
        }
        
        completion(nil)
      },
      failure:
      { (error) in
        print(error)
        completion(error)
      })
  }
  
  func getLists(completion: @escaping ([List]?, Error?) -> Void) {
    if let lists = ListManager.lists {
      completion(lists, nil)
      return
    }
    let  url = URL(string: glb_Domain + "/lists")!
    let networkOperation = NetworkOperation(url: url)
    networkOperation.sendHttpGetRequest({
      (data, error) in
      guard let data = data,
        error == nil else {
          completion(nil, error ?? NSError(domain: "Error: Network error", code: 0 , userInfo: nil))
        return
      }
      do {
        ListManager.lists = try JSONDecoder().decode(Array<List>.self, from: data)
        completion(ListManager.lists, nil)
        return
      } catch let error {
        print(error)
        completion(nil, NSError(domain: error.localizedDescription, code: 0 , userInfo: nil))
      }
    })
  }
  
  func deleteList() {
    
  }
  
  func addTask(list: List, description: String, completion: @escaping (Error?) -> Void) {
    let params = [
      "description": description
    ]
    
    let  url = URL(string: glb_Domain + "/lists/" + list._id + "/tasks")!
    let networkOperation = NetworkOperation(url: url)
    
    networkOperation.sendHttpPostRequest(params,
      success:
      { (data) in
        if let result = String(data: data, encoding: .utf8) {
          print(result)
        }
        
        guard let task = try? JSONDecoder().decode(Task.self, from: data) else {
          print("Error: Could not decode data")
          return
        }
        
        if let delegate = ListManager.delegate {
          delegate.didAddTask(task: task, sender: self)
        }
        
        completion(nil)
    },
    failure:
      { (error) in
        print(error)
        completion(error)
    })
  }
  
  func getTasks(list: List, completion: @escaping ([Task]?, Error?) -> Void) {
    let  url = URL(string: glb_Domain + "/lists/" + list._id + "/tasks")!
    let networkOperation = NetworkOperation(url: url)
    networkOperation.sendHttpGetRequest({
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
