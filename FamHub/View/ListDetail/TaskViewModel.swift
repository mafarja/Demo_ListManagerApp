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
  let description: String
  let list_id: String
  let completed: Bool
  
  init(task: Task) {
    self.task = task
    self.id = task.id
    self.description = task.description ?? ""
    self.list_id = task.list_id
    self.completed = task.completed
  }
}
