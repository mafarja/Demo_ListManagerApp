//
//  List.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(List)

class List: NSManagedObject, Codable {
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case list_name = "name"
    case list_description = "description"
    case status
    case created
    case date_modified
  }
  
  @NSManaged var id: String?
  @NSManaged var list_name: String?
  @NSManaged var list_description: String?
  @NSManaged var status: String?
  @NSManaged var created: Date?
  @NSManaged var date_modified: Date?
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
        let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedObjectContext) else {
        fatalError("Failed to decode List")
    }
    
  

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(String.self, forKey: .id)
    self.list_name = try container.decodeIfPresent(String.self, forKey: .list_name)
    self.list_description = try container.decodeIfPresent(String.self, forKey: .list_description)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.created = try container.decodeIfPresent(Date.self, forKey: .created)
    self.date_modified = try container.decodeIfPresent(Date.self, forKey: .date_modified)
  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(list_name, forKey: .list_name)
    try container.encode(list_description, forKey: .list_description)
    try container.encode(status, forKey: .status)
    try container.encode(created, forKey: .created)
    try container.encode(date_modified, forKey: .date_modified)
  }
}
