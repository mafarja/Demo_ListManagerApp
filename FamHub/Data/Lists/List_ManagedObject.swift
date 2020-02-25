//
//  List.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(List_ManagedObject)

class List_ManagedObject: NSManagedObject {
   
  @NSManaged var id: String
  @NSManaged var list_name: String
  @NSManaged var list_description: String?
  @NSManaged var created: Date
  @NSManaged var date_modified: Date
  @NSManaged var user_id: String
  @NSManaged var isArchived: Bool
