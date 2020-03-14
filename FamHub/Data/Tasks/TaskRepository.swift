//
//  TaskRespository.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 11/27/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation
import CoreData

class TaskRepository: Repository {
  
  let coreDataManager = CoreDataManager()
  
  func getAll(identifier: String?) -> [Task] {
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    
    if let list_id = identifier {
      fetchRequest.predicate = NSPredicate(format: "list_id == %@", list_id)
    }
    
    let sort = NSSortDescriptor(key: #keyPath(Task.posted), ascending: false)
    fetchRequest.sortDescriptors = [sort]
    
    let tasks_MO = (try? CoreDataManager.backgroundContext.fetch(fetchRequest)) as! [Task_ManagedObject]
    
    var tasks: [Task] = []
    
    for task_MO in tasks_MO {
      
      if let date_modified = task_MO.date_modified {
        var task = Task(id: task_MO.id, description: task_MO.task_description, list_id: task_MO.list_id, completed: task_MO.completed, posted: task_MO.posted, order: task_MO.order, deleted: task_MO.deleted_LM, date_modified: date_modified)
        tasks.append(task)
      } else {
        var task = Task(id: task_MO.id, description: task_MO.task_description, list_id: task_MO.list_id, completed: task_MO.completed, posted: task_MO.posted, order: task_MO.order, deleted: task_MO.deleted_LM, date_modified: Date())
        tasks.append(task)
      }
      
      
    }
    
    return tasks
  }
  
  func get(identifier: Int) -> Task? {
    
    return Task(id: "213", description: "123", list_id: "123", completed: false, posted: Date(), order: 0, deleted: false, date_modified: Date())
  }
  
  func create(a: Task) -> Bool {
    
    let task_ManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Task", into: CoreDataManager.backgroundContext) as! Task_ManagedObject

    task_ManagedObject.setValue(a.id, forKey: "id")
    task_ManagedObject.setValue(a.description, forKey: "task_description")
    task_ManagedObject.setValue(a.posted, forKeyPath: "posted")
    task_ManagedObject.setValue(a.list_id, forKey: "list_id")
    task_ManagedObject.setValue(a.completed, forKey: "completed")

    self.save()
    
    return true
  }
  
  func update(a: Task) -> Bool {
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "id == %@", a.id)

    let task_ManagedObjectArr = (try? CoreDataManager.backgroundContext.fetch(fetchRequest)) as! [Task_ManagedObject]
    
    if task_ManagedObjectArr.count == 0 {
      return false
    }
    
    let task_ManagedObject = task_ManagedObjectArr[0]
      
    task_ManagedObject.setValue(a.id, forKey: "id")
    task_ManagedObject.setValue(a.description, forKey: "task_description")
    task_ManagedObject.setValue(a.posted, forKeyPath: "posted")
    task_ManagedObject.setValue(a.list_id, forKey: "list_id")
    task_ManagedObject.setValue(a.completed, forKey: "completed")
    task_ManagedObject.setValue(a.order, forKey: "order")
    task_ManagedObject.setValue(a.deleted, forKey: "deleted_LM")
    task_ManagedObject.setValue(a.date_modified, forKey: "date_modified")

    self.save()
    
    return true

  }
  
  func delete(a: Task) -> Bool {
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "id == %@", a.id)

    let task_ManagedObjectArr = (try? CoreDataManager.backgroundContext.fetch(fetchRequest)) as! [Task_ManagedObject]
    
    if task_ManagedObjectArr.count == 0 {
      return false
    }
    
    let task_ManagedObject = task_ManagedObjectArr[0]
      
    CoreDataManager.backgroundContext.delete(task_ManagedObject)
    
    self.save()
    
    return true

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
