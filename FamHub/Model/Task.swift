//
//  Response.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)

class Task: NSManagedObject, Codable {
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case task_description = "description"
    case status
    case posted
    case list_id
    case date_modified
  }
  
  @NSManaged var id: String?
  @NSManaged var task_description: String?
  @NSManaged var status: String?
  @NSManaged var posted: Date?
  @NSManaged var list_id: String?
  @NSManaged var date_modified: Date?
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
        let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedObjectContext) else {
        fatalError("Failed to decode Task")
    }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(String.self, forKey: .id)
    self.list_id = try container.decodeIfPresent(String.self, forKey: .list_id)
    self.task_description = try container.decodeIfPresent(String.self, forKey: .task_description)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.posted = try container.decodeIfPresent(Date.self, forKey: .posted)
    self.date_modified = try container.decodeIfPresent(Date.self, forKey: .date_modified)
  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(list_id, forKey: .list_id)
    try container.encode(task_description, forKey: .task_description)
    try container.encode(status, forKey: .status)
    try container.encode(posted, forKey: .posted)
    try container.encode(date_modified, forKey: .date_modified)
  }
}
