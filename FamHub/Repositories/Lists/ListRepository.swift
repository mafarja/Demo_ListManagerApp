//
//  ListRepository.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 11/25/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

class ListRepository: Repository {
  
  let coreDataManager = CoreDataManager()
  
  func getAll(identifier: String?) -> [List] {
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
    
    let sort = NSSortDescriptor(key: #keyPath(List.created), ascending: false)
       fetchRequest.sortDescriptors = [sort]
    
    let lists_MO = (try? CoreDataManager.backgroundContext.fetch(fetchRequest)) as! [List_ManagedObject]
    
    var lists: [List] = []
    
    for list_MO in lists_MO {
      var list = List(id: list_MO.id, name: list_MO.list_name, user_id: list_MO.user_id, description: list_MO.list_description, created: list_MO.created, date_modified: list_MO.date_modified, isArchived: list_MO.isArchived, tasks: nil)
      lists.append(list)
  
    }
    
    return lists
  }
  
  func get(identifier: Int) -> List? {
    
    return List(id: "123", name: "123", user_id: "123", description: "123", created: Date(), date_modified: Date(), isArchived: false, tasks: nil)
  }
  
  func create(a: List) -> Bool {
    
    let list_ManagedObject = NSEntityDescription.insertNewObject(forEntityName: "List", into: CoreDataManager.backgroundContext) as! List_ManagedObject

    list_ManagedObject.setValue(a.id, forKey: "id")
    list_ManagedObject.setValue(a.name, forKey: "list_name")
    if let description = a.description {
      list_ManagedObject.setValue(description, forKey: "list_description")
    }
    list_ManagedObject.setValue(a.date_modified, forKey: "date_modified")
    list_ManagedObject.setValue(a.created, forKeyPath: "created")
    list_ManagedObject.setValue(a.user_id, forKey: "user_id")
    list_ManagedObject.setValue(a.isArchived, forKey: "isArchived")

    self.save()
    
    return true
  }
  
  func update(a: List) -> Bool {
    
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
    fetchRequest.predicate = NSPredicate(format: "id == %@", a.id)
    let list_ManagedObjectArr = (try? CoreDataManager.backgroundContext.fetch(fetchRequest)) as! [List_ManagedObject]
    
    if list_ManagedObjectArr.count == 0 {
      return false
    }
    
    let list_ManagedObject = list_ManagedObjectArr[0]
    
    list_ManagedObject.setValue(a.id, forKey: "id")
    list_ManagedObject.setValue(a.name, forKey: "list_name")
    if let description = a.description {
      list_ManagedObject.setValue(description, forKey: "list_description")
    }
    list_ManagedObject.setValue(a.date_modified, forKey: "date_modified")
    list_ManagedObject.setValue(a.created, forKeyPath: "created")
    list_ManagedObject.setValue(a.user_id, forKey: "user_id")
    list_ManagedObject.setValue(a.isArchived, forKey: "isArchived")
    
    self.save()
    return true

  }
  
  func delete(a: List) -> Bool {
    
    
    return false

  }
  

  
  private func save() {
    if CoreDataManager.backgroundContext.hasChanges {
      do {
        try CoreDataManager.backgroundContext.save()

        
      } catch let error {
        print("Error saving context \(error)")
      }
    }
  }
}
