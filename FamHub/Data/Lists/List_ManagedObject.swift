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
  
  
//  let dataSync = DataSync.shared
//  
//  override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
//    super.init(entity: entity, insertInto: context)
//    
//    self.dataSync.delegate = self
//   
//    
//  }
  
//  required convenience init(from decoder: Decoder) throws {
//    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
//      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
//        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedObjectContext) else {
//        fatalError("Failed to decode List")
//    }
//
//    self.init(entity: entity, insertInto: managedObjectContext)
//
//  }
  
//  func getTasks() -> [Task] {
//    
//   
//    
//    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
//    fetchRequest.predicate = NSPredicate(format: "list_id == %@", self.id)
//    let sort = NSSortDescriptor(key: #keyPath(Task.posted), ascending: false)
//    fetchRequest.sortDescriptors = [sort]
//    
//    let tasks = (try? self.managedObjectContext!.fetch(fetchRequest)) as! [Task]
//    
//    return tasks
//  }
//  
//  func addTask(description: String) -> Task? {
//    
//    print(self.managedObjectContext)
//    guard let managedObjectContext = self.managedObjectContext,
//      var task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedObjectContext) as? Task else {
//        
//     
//        
//        
//        return nil}
//    
//    let objectId = Utils().objectId()
//    
//    task.setValue(objectId, forKeyPath: "id")
//    task.setValue(description, forKeyPath: "task_description")
//    task.setValue(self.id, forKeyPath: "list_id")
//    let now = Date()
//    task.setValue(now, forKey: "posted")
//    task.setValue(now, forKey: "date_modified")
//    
//    self.save()
//    
//    return task
//  }
//  
//  func markTaskCompleted(task_id: String) {
//    
//    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
//    fetchRequest.predicate = NSPredicate(format: "id == %@", task_id)
//    
//    let task = ((try? self.managedObjectContext!.fetch(fetchRequest)) as! [Task])[0]
//    task.setValue(true, forKey: "completed")
//    task.setValue(Date(), forKey: "date_modified")
//    
//    self.save()
//  }
//  
//  func undoTaskCompleted(task_id: String) {
//    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
//    fetchRequest.predicate = NSPredicate(format: "id == %@", task_id)
//    
//    let task = ((try? self.managedObjectContext!.fetch(fetchRequest)) as! [Task])[0]
//    task.setValue(false, forKey: "completed")
//    task.setValue(Date(), forKey: "date_modified")
//    
//    self.save()
//  }
//  
//  
//  private func save() {
//    
//    if self.managedObjectContext!.hasChanges {
//      do {
//        try self.managedObjectContext!.save()
//        
//        self.dataSync.sync() {
//          (error) in
//    
//        }
//      } catch let error {
//        print("Error saving context \(error)")
//      }
//      
//    }
//  }
}

//extension List_ManagedObject: DataSyncDelegate {
//  func didCompleteDataSync() {
//    
//  }
//  
//  
//}


