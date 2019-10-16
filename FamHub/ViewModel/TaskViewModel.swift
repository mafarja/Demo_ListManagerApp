//
//  TaskViewModel.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct TaskViewModel {
  let id: String
  let description: String
  let list_id: String
  
  init(task: Task) {
    self.id = task.id!
    self.description = task.task_description ?? ""
    self.list_id = task.list_id!
  }
}
