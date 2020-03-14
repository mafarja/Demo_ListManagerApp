//
//  Task_ManagedObject.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 11/27/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Task_ManagedObject)

class Task_ManagedObject: NSManagedObject {
  
  @NSManaged var id: String
  @NSManaged var task_description: String
  @NSManaged var completed: Bool
  @NSManaged var posted: Date
  @NSManaged var list_id: String
  @NSManaged var order: Int
  @NSManaged var deleted_LM: Bool
  @NSManaged var date_modified: Date?
  
}

