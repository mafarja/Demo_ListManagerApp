//
//  DataSync.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/25/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class DataSync: NSObject {
  
  var service: FHService!
  let listRepo = ListRepository()
  let taskRepo = TaskRepository()
  
  static var lastSync: Date? {
    get {
      
      return UserDefaults.standard.object(forKey: "lastSync") as? Date }
    set {
      
      UserDefaults.standard.set(newValue, forKey:"lastSync") }
  }
  
  var syncIntervalInSecs: Int?

  init(service: FHService, intervalInSecs: Int?) {
    super.init()
    self.service = service
    self.sync()
    self.syncIntervalInSecs = intervalInSecs
    self.setTimer()
    
  }
  
  convenience init(intervalInSecs: Int?) {
    
    let service = FamHubAPI()
    self.init(service: service, intervalInSecs: intervalInSecs)
    
  }
  
  //TODO 4. Function timer which calls sync at the set time interval
  func setTimer() {
    guard let interval = self.syncIntervalInSecs else { return }
    
    let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { timer in
      self.sync()
    }
  }

  @objc func sync(_ completion: ((Error?) -> Void)? = nil) {
    
    getLocalItemsWithModifiedDateGreaterThanLastSync() { (lists) in
      
      self.postItemsToServerAndFetchModifiedItems(lists: lists) {
        (lists, tasks, error)   in
        
        
        
        self.saveToRespository(lists: lists, tasks: tasks)
        
        guard let completion = completion else { return }
        
        if (error != nil) {
          completion(error)
          return
        }
        completion(nil)
      }
    }
  }
  
  
  private func didCompleteDataSync() {
    DataSync.lastSync = Date()
    NotificationCenter.default.post(name: .didCompleteDataSync, object: nil)
  }
  
  private func saveToRespository(lists: [List]?, tasks: [Task]?) {
    if let lists = lists {
      
      
      for list in lists {
        if self.listRepo.update(a: list) {
          continue
        } else {
         _ = self.listRepo.create(a: list)
        }
      }
    }
    
    if let tasks = tasks {
      for task in tasks {
        if self.taskRepo.update(a: task) {
          continue
        } else {
          _ = self.taskRepo.create(a: task)
        }
      }
    }
    
    self.didCompleteDataSync()
  }

  private func getLocalItemsWithModifiedDateGreaterThanLastSync(_ completion: @escaping ([List]) -> Void) {
    var lists = [List]()
    
    for list in self.listRepo.getAll(identifier: nil) {
      
      if let lastSync = DataSync.lastSync {
        
        if lastSync > list.date_modified {
          continue
        }
      }
      for task in self.taskRepo.getAll(identifier: list.id) {
        list.tasks.value.append(task)
      }
      lists.append(list)
    }
    
    completion(lists)
  }
  
  private func postItemsToServerAndFetchModifiedItems(lists: [List], completion: @escaping ([List]?, [Task]?, Error?) -> Void) {
    
    var listObjArr: [[String: Any]] =  []
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    for list in lists {
      var listObj = [
        "name": list.name
      ] as [String : Any]
      
      if let description = list.description {
        listObj["description"] = description
      }
      
      listObj["created"] = dateFormatter.string(from: list.created)
      listObj["date_modified"] = dateFormatter.string(from: list.date_modified)
      listObj["_id"] = list.id
      listObj["user_id"] = list.user_id
      listObj["isArchived"] = list.isArchived
      
      var taskObjArr: [[String: Any]] = []
      
      for task in list.tasks.value {
        var taskObj = [
          "description": task.description,
          "list_id": task.list_id
          ] as [String : Any]
        
        taskObj["posted"] = dateFormatter.string(from: task.posted)
        taskObj["_id"] = task.id
        taskObj["completed"] = task.completed
        taskObj["order"] = task.order
        taskObj["deleted"] = task.deleted
        taskObj["date_modified"] = dateFormatter.string(from: task.date_modified ?? Date())
        taskObjArr.append(taskObj)
      }
      listObj["tasks"] = taskObjArr
      
      listObjArr.append(listObj)
    }
    
    
    
    User().getUserId { (userId) in
      guard let user_id = userId else {
        print("Error: UserId is needed to perform sync opertion.")
        return
      }
      
      self.service.sync(user_id: user_id, lastSync: DataSync.lastSync, lists: listObjArr) { (data, error) in
        
        guard let data = data,
          error == nil else {
            completion(nil, nil, error)
            return
        }
        
        let dataString = String(data: data, encoding: .utf8)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
          
        
        do {
          let dataSyncResponse = try decoder.decode(DataSyncResponse.self, from: data)
          
          for list in dataSyncResponse.lists {
            print(list.created)
          }
          
          var tasks = [Task]()
          for list in dataSyncResponse.lists {
            tasks.append(contentsOf: list.tasks.value)
          }
          
          completion(dataSyncResponse.lists, tasks, nil)
        } catch let error {
          print(error)
          completion(nil, nil, error)
        }
      }
    }
  }
}


