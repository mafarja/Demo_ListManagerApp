//
//  List.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol ListDelegate {
  func listDidUpdate()
}

class List: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case description
    case created
    case date_modified
    case user_id
    case isArchived
    case tasks
  }
  
  var taskRepo = TaskRepository()
  var listRepo = ListRepository()
  
  var id: String
  var name: String
  var description: String?
  @objc var created: Date
  var date_modified: Date
  var user_id: String
  var isArchived: Bool = false
  var tasks: Observable<[Task]> = Observable<[Task]>([])
  var delegate: ListDelegate?
  
  
  init(id: String, name: String, user_id: String, description: String?, created: Date, date_modified: Date, isArchived: Bool, tasks: [Task]?) {
    
    self.id = id
    self.name = name
    self.user_id = user_id
    self.created = created
    self.date_modified = date_modified
    if let description = description {
      self.description = description
    }
    self.isArchived = isArchived
    if let tasks = tasks {
      self.tasks.value = tasks
    } else {
      self.tasks.value = self.getTasks()
    }
    
    
  }
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(String.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let user_id = try container.decode(String.self, forKey: .user_id)
    let description = try container.decodeIfPresent(String.self, forKey: .description)
    let created = try container.decode(Date.self, forKey: .created)
    let date_modified = try container.decode(Date.self, forKey: .date_modified)
    let isArchived = try (container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false)
    let tasks = try (container.decode([Task].self, forKey: .tasks))
    
    self.init(id: id, name: name, user_id: user_id, description: description, created: created, date_modified: date_modified, isArchived: isArchived, tasks: tasks)
  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(description, forKey: .description)
    try container.encode(created, forKey: .created)
    try container.encode(date_modified, forKey: .date_modified)
    try container.encode(user_id, forKey: .user_id)
    try container.encode(isArchived, forKey: .isArchived)
    try container.encode(tasks.value, forKey: .tasks)
  }
  
  func getTasks() -> [Task] {
    
    return self.taskRepo.getAll(identifier: self.id)
    
  }
  
  func addTask(description: String) -> Task? {
    
    let task = Task(id: Utils().objectId(), description: description, list_id: self.id, completed: false, posted: Date(), order: 0, deleted: false, date_modified: Date())
    
    guard self.taskRepo.create(a: task) else {
      return nil
    }
    
    self.tasks.value = self.getTasks()
    
    self.delegate?.listDidUpdate()

    self.updateListDateModified()
    
    return task
  }
  
  func updateTasks(taskViewModels: [TaskViewModel]) {
    
    for (index, taskViewModel) in taskViewModels.enumerated() {
      guard self.taskRepo.update(a: Task(
        id: taskViewModel.id,
        description: taskViewModel.description,
        list_id: taskViewModel.list_id,
        completed: taskViewModel.completed,
        posted: taskViewModel.posted,
        order: index,
        deleted: taskViewModel.deleted,
        date_modified: taskViewModel.date_modified)
      )
      else { return }
    }
    
    self.tasks.value = self.taskRepo.getAll(identifier: self.id)
    
    self.updateListDateModified()
    
  }
  
  func markTaskCompleted(task_id: String) {
    
    for (index, task) in self.tasks.value.enumerated() {
      if task.id == task_id {
        task.completed = true
        
        guard self.taskRepo.update(a: task) else { return }
        self.tasks.value = getTasks()
        
      }
    }
    
    self.delegate?.listDidUpdate()
    
    self.updateListDateModified()

  }
  
  func undoTaskCompleted(task_id: String) {
    for (index, task) in self.tasks.value.enumerated() {
       if task.id == task_id {
         task.completed = false
         
         guard self.taskRepo.update(a: task) else { return }
         self.tasks.value = getTasks()
       }
     }
    
    self.delegate?.listDidUpdate()
    
    self.updateListDateModified()

  }
  
  func delete(task: Task) {
    task.delete()
    self.updateListDateModified()
    self.tasks.value = self.taskRepo.getAll(identifier: self.id)
    self.delegate?.listDidUpdate()
  }
  
  private func updateListDateModified() {
    self.date_modified = Date()
    self.listRepo.update(a: self)
  }
  

}

extension List: Equatable {
  static func == (lhs: List, rhs: List) -> Bool {
    return
        lhs.id == rhs.id &&
        lhs.description == rhs.description &&
        lhs.isArchived == rhs.isArchived &&
        lhs.name == rhs.name
    
  }
}
