//
//  ListManager.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class ListManager {
  
  var repository: ListRepository!
    
  static var lists: Observable<[List]> = Observable<[List]>([])
  
  init(repository: ListRepository) {
    
    self.repository = repository
    
    
  }
  
  convenience init() {
    
    let repository = ListRepository()
    self.init(repository: repository)
    
  }
  
  func addList(name: String, description: String?, completion: @escaping (List?) -> Void) {
    self.createList(name: name, description: description) { list, error in
      guard let list = list,
        error == nil,
        self.repository.create(a: list) else {
          completion(nil)
          return
      }
        
        list.delegate = self
      
      ListManager.lists.value.insert(list, at: 0)
      
      completion(list)
    }
  }
  
  private func createList(name: String, description: String?, completion: @escaping (List?, Error?) -> Void) {
    
    User().getUserId { (user_id) in
      guard let user_id = user_id else {
        completion(nil, NSError(domain: "Could not obtain CloudKit user id.", code: 0, userInfo: nil))
        return
      }
      
      let list = List(id: Utils().objectId(), name: name, user_id: user_id, description: description, created: Date(), date_modified: Date(), isArchived: false, tasks: nil)
      
      if let description = description {
        list.description = description
      }
      
      completion(list, nil)
      
    }
  }
  
  func getLists() {
    
    ListManager.lists.value = self.repository.getAll(identifier: nil)
    
    for list in ListManager.lists.value {
      list.delegate = self
    }
    
  }
  
  func archive(list_id: String) {
    
    for (index, list) in ListManager.lists.value.enumerated() {
      if list.id == list_id {
        list.isArchived = true
        list.date_modified = Date()
        guard self.repository.update(a: list) else { return }
        self.getLists()
      }
    }
  }
}

extension ListManager: ListDelegate {
  func listDidUpdate() {
    self.getLists()
  }
  
  
}

