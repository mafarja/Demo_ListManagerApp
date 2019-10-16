//
//  FamHubService.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/14/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol FHService {
  func getLists()
  
  func addList()
  
  func getTasks(list_id: String)
  
  func addTask(list_id: String)
  
  func sync(lists: [[String: Any]], tasks: [[String: Any]], completion: @escaping (Data?, Error?) -> Void)
}
