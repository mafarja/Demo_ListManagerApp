//
//  ListViewModel.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol ListViewModelDelegate {
  func didUpdate()
}

class ListViewModel {
  
  let list: List
  let id: String
  var name: String
  var description: String
  var isArchived: Bool
  var taskViewModels: [TaskViewModel]
  var delegate: ListViewModelDelegate?
  var isEditMode: Observable<Bool> = Observable<Bool>(false)
  var numberTasksCompleted = 0
  var totalNumberOfTasks = 0
  
  init(list: List) {
    self.list = list
    self.id = list.id
    self.name = list.name
    self.description = list.description ?? ""
    self.isArchived = list.isArchived
    self.taskViewModels = self.list.tasks.value.map {
      TaskViewModel(task: $0)
    }
    
    registerModelObservers()
    
  }
  
  func registerModelObservers() {
    self.list.tasks.addObserver(self, options: [.initial, .new]) { tasks, change in
    
      self.loadTaskViewModels(tasks: tasks)
      
    }
  }
  
  func loadTaskViewModels(tasks: [Task]) {
    
    self.taskViewModels = []
    
    for task in tasks {
      self.taskViewModels.append(TaskViewModel(task: task))
      
      if (task.completed && !task.deleted) {
        self.numberTasksCompleted += 1
      }
      
    }
    
    let minus_deleted = self.taskViewModels.filter {
      $0.deleted == false
    }
    
    self.taskViewModels = minus_deleted
    
    self.taskViewModels.sort(by: { $0.order < $1.order })
    
    self.totalNumberOfTasks = self.taskViewModels.count
    
    self.delegate?.didUpdate()
  }
  
  func addTask(description: String) {
    self.list.addTask(description: description)
  }
  
  func delete(task: TaskViewModel) {
    self.list.delete(task: Task(id: task.id, description: task.description, list_id: task.list_id, completed: task.completed, posted: task.posted, order: task.order, deleted: task.deleted, date_modified: task.date_modified))
  }
  
  func moveTask(taskViewModel: TaskViewModel, removeAtIndex: Int, insertAtIndex: Int) {
    self.taskViewModels.remove(at: removeAtIndex)
    self.taskViewModels.insert(taskViewModel, at: insertAtIndex )
    
    self.list.updateTasks(taskViewModels: self.taskViewModels)
  }
  
  func markTaskCompleted(task_id: String) {
    self.list.markTaskCompleted(task_id: task_id)
  }
  
  func undoTaskCompleted(task_id: String) {
    self.list.undoTaskCompleted(task_id: task_id)
  }
}

extension ListViewModel: Equatable {
  static func == (lhs: ListViewModel, rhs: ListViewModel) -> Bool {
    return lhs.list == rhs.list
  }
  
}






