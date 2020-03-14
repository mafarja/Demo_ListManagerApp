//
//  TaskViewModel.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct TaskViewModel {
  private let task: Task
  let id: String
  var description: String
  let list_id: String
  var completed: Bool
  var posted: Date
  var order: Int
  var deleted: Bool
  let date_modified: Date
  
  init(task: Task) {
    self.task = task
    self.id = task.id
    self.description = task.description ?? ""
    self.list_id = task.list_id
    self.completed = task.completed
    self.posted = task.posted
    self.order = task.order
    self.deleted = task.deleted
    self.date_modified = task.date_modified ?? Date()
  }
}
