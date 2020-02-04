//
//  CoreDataManager.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 11/25/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
  
  
  static var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FamHub")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
//  func saveContext () {
//    let context = CoreDataManager.persistentContainer.viewContext
//    if context.hasChanges {
//      do {
//        try context.save()
//      } catch {
//        // Replace this implementation with code to handle the error appropriately.
//        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nserror = error as NSError
//        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//      }
//    }
//  }
  
  static var backgroundContext: NSManagedObjectContext = {
    return CoreDataManager.persistentContainer.newBackgroundContext()
  }()
  
  init() {
 
    
   
  }
  

  
}
