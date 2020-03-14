//
//  Response.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class Task: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case description
    case completed
    case posted
    case list_id
    case order
    case deleted
    case date_modified
  }
  
  var id: String
  var description: String
  var completed: Bool
  @objc var posted: Date
  var list_id: String
  var order: Int
  var deleted: Bool
  var date_modified: Date?
  
  let taskRepo = TaskRepository()
  
  init(id: String, description: String, list_id: String, completed: Bool, posted: Date, order: Int, deleted: Bool?, date_modified: Date) {
    self.id = id
    self.description = description
    self.completed = completed
    self.posted = posted
    self.list_id = list_id
    self.order = order
    self.deleted = deleted ?? false
    self.date_modified = date_modified
    
  }
  
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let list_id = try container.decode(String.self, forKey: .list_id)
    let description = try container.decode(String.self, forKey: .description)
    let id = try container.decode(String.self, forKey: .id)
    let completed = try container.decode(Bool.self, forKey: .completed)
    let posted = try container.decode(Date.self, forKey: .posted)
    var order = 0
    if let o = try? container.decode(Int.self, forKey: .order) {
      order = o
    }
    var deleted = false
    if let del = try? container.decode(Bool.self, forKey: .deleted) {
      deleted = del
    }
    var date_modified = Date()
    if let dm = try? container.decode(Date.self, forKey: .date_modified) {
      date_modified = dm
    }
    

    self.init(id: id, description: description, list_id: list_id, completed: completed, posted: posted, order: order, deleted: deleted, date_modified: date_modified)

  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(list_id, forKey: .list_id)
    try container.encode(description, forKey: .description)
    try container.encode(completed, forKey: .completed)
    try container.encode(posted, forKey: .posted)
    try container.encode(order, forKey: .order)
    try container.encode(deleted, forKey: .deleted)
    try container.encode(date_modified, forKey: .date_modified)
  }
  
  func delete() {
    self.deleted = true
    
    self.taskRepo.update(a: self)
    self.updateTaskDateModified()
  }
  
  private func updateTaskDateModified() {
    self.date_modified = Date()
    self.taskRepo.update(a: self)
  }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.completed == rhs.completed &&
            //lhs.date_modified == rhs.date_modified &&
            lhs.deleted == rhs.deleted &&
            lhs.description == rhs.description &&
            lhs.id == rhs.id &&
            lhs.list_id == rhs.list_id &&
            lhs.order == rhs.order &&
            lhs.posted == rhs.posted
        
    }
}
