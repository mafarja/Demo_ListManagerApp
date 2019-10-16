//
//  DataSync.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/25/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import CoreData

protocol DataSyncDelegate {
  func didCompleteDataSync()
}

class DataSync: NSObject {
  var service: FHService!
  var delegate: DataSyncDelegate?
  static var lastSync: Date?
  
  var persistentContainer: NSPersistentContainer!
  
  lazy var backgroundContext: NSManagedObjectContext = {
    return self.persistentContainer.newBackgroundContext()
  }()
  
  init(container: NSPersistentContainer, service: FHService) {
    super.init()
    self.persistentContainer = container
    self.service = service
  }
  
  convenience override init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot get shared app delegate")
    }
    let service = FamHubAPI()
    self.init(container: appDelegate.persistentContainer, service: service)
  }
  
  func sync(_ completion: @escaping (Error?) -> Void) {
    
    getLocalItemsWithModifiedDateGreaterThanLastSync() { (lists, tasks) in
      
      
      self.postItemsToServerAndFetchModifiedItems(lists: lists, tasks: tasks) {
        (error)  in
        if (error != nil) {
          completion(error)
        }
        
        if let delegate = self.delegate {
          DataSync.lastSync = Date()
          delegate.didCompleteDataSync()
        }
        completion(nil)
      }
    }
  }

  private func getLocalItemsWithModifiedDateGreaterThanLastSync(_ completion: @escaping ([List], [Task]) -> Void) {
    var lists = [List]()
    var tasks = [Task]()

    var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
    
    if let lastSyncDate = DataSync.lastSync {
      fetchRequest.predicate = NSPredicate(format: "date_modified > %@", lastSyncDate as CVarArg)
    }
    
    do {
      lists = try backgroundContext.fetch(fetchRequest) as! [List]
      
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    // get tasks
    fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
    
    if let lastSyncDate = DataSync.lastSync {
      fetchRequest.predicate = NSPredicate(format: "date_modified > %@", lastSyncDate as CVarArg)
    }
    
    do {
      tasks = try backgroundContext.fetch(fetchRequest) as! [Task]
      
     } catch let error as NSError {
       print("Could not fetch. \(error), \(error.userInfo)")
     }
    completion(lists, tasks)
  }
  
  private func postItemsToServerAndFetchModifiedItems(lists: [List], tasks: [Task], completion: @escaping (Error?) -> Void) {
    
    var listObjArr: [[String: Any]] =  []
    var taskObjArr: [[String: Any]] = []
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    
    for list in lists {
      var listObj = [
        "name": list.list_name
      ] as [String : Any]
      
      if let description = list.list_description {
        listObj["description"] = description
      }
      if let created = list.created {
        listObj["created"] = dateFormatter.string(from: created)
      }
      if let date_modified = list.date_modified {
        listObj["date_modified"] = dateFormatter.string(from: date_modified)
      }
      if let id = list.id {
        listObj["_id"] = id
      }
      listObjArr.append(listObj)
    }
    
    for task in tasks {
      var taskObj = [
        "description": task.task_description,
        "list_id": task.list_id
        ] as [String : Any]
      
      if let posted = task.posted {
        taskObj["posted"] = dateFormatter.string(from: posted)
      }
      if let date_modified = task.date_modified {
        taskObj["date_modified"] = dateFormatter.string(from: date_modified)
      }
      
      if let id = task.id {
        taskObj["_id"] = id
      }
      if let status = task.status {
        taskObj["status"] = status
      }
      taskObjArr.append(taskObj)
    }
    
    
    self.service.sync(lists: listObjArr, tasks: taskObjArr) { (data, error) in
      
      
      guard let data = data,
        error == nil else {
          completion(error)
          return
      }
      let dataString = String(data: data, encoding: .utf8)
      print("yoyos", dataString)
      
      do {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
          
          
          
          fatalError()
        }
        
        self.clearStorage()
        
        let managedObjectContext = self.backgroundContext
        
        let decoder = JSONDecoder()
        
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = self.backgroundContext
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        do {
          let dataSyncResponse = try decoder.decode(DataSyncResponse.self, from: data)
        } catch let error {
          print(error)
          
        }
        
        
        do {
          try self.backgroundContext.save()
        } catch let error {
          print("Error: Could not save context \(error)")
        }
        
        completion(nil)
      } catch let error {
        print(error)
        completion(error)
        return
      }
    }
  
  }
  
  func clearStorage() {
    
    let fetchRequestList:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
    let lists = try! backgroundContext.fetch(fetchRequestList)
    for case let obj as NSManagedObject in lists {
      backgroundContext.delete(obj)
    }
    
    let fetchRequestTask:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    
    let tasks = try! backgroundContext.fetch(fetchRequestTask)
    for case let obj as NSManagedObject in tasks {
      backgroundContext.delete(obj)
    }
    
  }
}
