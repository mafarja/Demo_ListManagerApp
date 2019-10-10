//
//  ListManager.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import CoreData

protocol ListManagerDelegate: AnyObject  {
  func didUpdateData()
}

class ListManager: NSObject {
  static var delegate: ListManagerDelegate?
  var dataSync: DataSync?
  var persistentContainer: NSPersistentContainer!
  
  lazy var backgroundContext: NSManagedObjectContext = {
    return self.persistentContainer.newBackgroundContext()
  }()
  
  init(container: NSPersistentContainer) {
    super.init()
    self.persistentContainer = container
    self.dataSync = DataSync()
    self.dataSync?.delegate = self
    
    if let dataSync = self.dataSync {
      if DataSync.lastSync == nil {
        dataSync.sync()
      }
    }
  }
  
  convenience override init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot get shared app delegate")
    }
    self.init(container: appDelegate.persistentContainer)
  }
  
  func addList(name: String, description: String?) -> List? {

    let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: backgroundContext) as! List

    let objectId = Utils().objectId()
    list.setValue(objectId, forKey: "id")
    
    list.setValue(name, forKey: "list_name")
    if let description = description {
      list.setValue(description, forKey: "list_description")
    }
    
    let now = Date()
    list.setValue(now, forKey: "date_modified")
    list.setValue(now, forKeyPath: "created")
    
    self.save()
    
    return list
  }
  
  func getLists() -> [List] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
    let sort = NSSortDescriptor(key: #keyPath(List.created), ascending: false)
       fetchRequest.sortDescriptors = [sort]
    let lists = (try? backgroundContext.fetch(fetchRequest)) as! [List]
    
    return lists
  }
  
  func deleteList() {
    // to implement
  }
  
  func addTask(description: String, list_id: String) -> Task? {
    let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: backgroundContext) as! Task
    
    let objectId = Utils().objectId()
    
    task.setValue(objectId, forKeyPath: "id")
    task.setValue(description, forKeyPath: "task_description")
    task.setValue(list_id, forKeyPath: "list_id")
    let now = Date()
    task.setValue(now, forKey: "posted")
    task.setValue(now, forKey: "date_modified")
    
    self.save()
    
    return task
  }
  
  func getTasks(list_id: String) -> [Task] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "list_id == %@", list_id)
    let sort = NSSortDescriptor(key: #keyPath(Task.posted), ascending: false)
    fetchRequest.sortDescriptors = [sort]
    
    let tasks = (try? persistentContainer.viewContext.fetch(fetchRequest)) as! [Task]
    
    return tasks
  }
  
  private func save() {
    if backgroundContext.hasChanges {
      do {
        try backgroundContext.save()
        
        if let dataSync = self.dataSync {
          dataSync.sync()
        }
        
        if let delegate = ListManager.delegate {
          delegate.didUpdateData()
        }
      } catch let error {
        print("Error saving context \(error)")
      }
    }
  }
}

extension ListManager: DataSyncDelegate {
  func didCompleteDataSync() {
    if let delegate = ListManager.delegate {
      delegate.didUpdateData()
    }
  }
}
