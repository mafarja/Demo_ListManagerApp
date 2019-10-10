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
  let service = NetworkOperation()
  var delegate: DataSyncDelegate?
  static var lastSync: Date?
  
  var persistentContainer: NSPersistentContainer!
  
  lazy var backgroundContext: NSManagedObjectContext = {
    return self.persistentContainer.newBackgroundContext()
  }()
  
  init(container: NSPersistentContainer, service: Service) {
    super.init()
    self.persistentContainer = container
  }
  
  convenience override init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot get shared app delegate")
    }
    let service = NetworkOperation()
    self.init(container: appDelegate.persistentContainer, service: service)
  }
  
  func sync() {
    
    getLocalItemsWithModifiedDateGreaterThanLastSync() { (lists, tasks) in
      self.postItemsToServerAndFetchModifiedItems(lists: lists, tasks: tasks) {
        (lists, tasks, error)  in
        
        if let delegate = self.delegate {
          DataSync.lastSync = Date()
          delegate.didCompleteDataSync()
        }
      }
    }
  }

  private func getLocalItemsWithModifiedDateGreaterThanLastSync(_ completion: @escaping ([List], [Task]) -> Void) {
    var lists = [List]()
    var tasks = [Task]()
  
    let managedContext = self.persistentContainer.viewContext
    
    DispatchQueue.global(qos: .background).async {
      var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
      
      if let lastSyncDate = DataSync.lastSync {
        fetchRequest.predicate = NSPredicate(format: "date_modified > %@", lastSyncDate as CVarArg)
      }
      
      do {
        lists = try managedContext.fetch(fetchRequest) as! [List]
        
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
      
      // get tasks
      fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
      
      if let lastSyncDate = DataSync.lastSync {
        fetchRequest.predicate = NSPredicate(format: "date_modified > %@", lastSyncDate as CVarArg)
      }
      
      do {
        tasks = try managedContext.fetch(fetchRequest) as! [Task]
        
       } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
       }
      completion(lists, tasks)
    }
  }
  
  private func postItemsToServerAndFetchModifiedItems(lists: [List], tasks: [Task], completion: @escaping ([List], [Task], Error?) -> Void) {
    
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
    
    let params = [
      "lists": listObjArr,
      "tasks": taskObjArr
    ]
   
    let  url = URL(string: glb_Domain + "/sync")!
    
    self.service.sendHttpPostRequest(url: url, params: params as [String : Any], completion: {
      (data, error) in
      
      let lists = [List]()
      let tasks = [Task]()
      
      guard let data = data,
        error == nil else {
          completion(lists, tasks, error)
          return
      }
      
      do {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
          fatalError()
        }
        
        self.clearStorage()
        
        let managedObjectContext = self.persistentContainer.viewContext
        
        let decoder = JSONDecoder()
        
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let dataSyncResponse = try decoder.decode(DataSyncResponse.self, from: data)
        
        do {
          try managedObjectContext.save()
        } catch let error {
          print("Error: Could not save context \(error)")
        }
       
        let lists = dataSyncResponse.lists
        let tasks = dataSyncResponse.tasks
        
        completion(lists, tasks, nil)
      } catch let error {
        print(error)
        completion(lists, tasks, NSError(domain: "Error: Decoding failed", code: 0, userInfo: nil))
        return
      }
    })
  }
  
  func clearStorage() {
    //clear lists
    let managedObjectContext = persistentContainer.viewContext
    let fetchListRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
    let batchDeleteListRequest = NSBatchDeleteRequest(fetchRequest: fetchListRequest)
    do {
        try managedObjectContext.execute(batchDeleteListRequest)
    } catch let error as NSError {
        print(error)
    }
  
    // now clear tasks
    let fetchTaskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    let batchDeleteTaskRequest = NSBatchDeleteRequest(fetchRequest: fetchTaskRequest)
    do {
        try managedObjectContext.execute(batchDeleteTaskRequest)
    } catch let error as NSError {
        print(error)
    }
  }
}
