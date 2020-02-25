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
  }
  
  var id: String
  var description: String
  var completed: Bool
  @objc var posted: Date
  var list_id: String
  
  init(id: String, description: String, list_id: String, completed: Bool, posted: Date) {
    self.id = id
    self.description = description
    self.completed = completed
    self.posted = posted
    self.list_id = list_id
  }
  
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let list_id = try container.decode(String.self, forKey: .list_id)
    let description = try container.decode(String.self, forKey: .description)
    let id = try container.decode(String.self, forKey: .id)
    let completed = try container.decode(Bool.self, forKey: .completed)
    let posted = try container.decode(Date.self, forKey: .posted)

    self.init(id: id, description: description, list_id: list_id, completed: completed, posted: posted)

  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(list_id, forKey: .list_id)
    try container.encode(description, forKey: .description)
    try container.encode(completed, forKey: .completed)
    try container.encode(posted, forKey: .posted)
  }
}
