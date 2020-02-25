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
    }
    
    self.delegate?.didUpdate()
  }
  
  func addTask(description: String) {
    self.list.addTask(description: description)
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

extension ListViewModel {
    /// The traditional method for rearranging rows in a table view.
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let taskViewModel = taskViewModels[sourceIndex]
        taskViewModels.remove(at: sourceIndex)
        taskViewModels.insert(taskViewModel, at: destinationIndex)
    }
    
    /// The method for adding a new item to the table view's data model.
    func addItem(_ taskViewModel: TaskViewModel, at index: Int) {
        taskViewModels.insert(taskViewModel, at: index)
    }
}




