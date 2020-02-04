//
//  ListManagerTests.swift
//  FamHubTests
//
//  Created by Marcelo Farjalla on 9/18/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import XCTest
import CoreData
@testable import FamHub

class ListManagerTests: XCTestCase {
  
  var sut: ListManager!
  
  override func setUp() {
    super.setUp()
    
    sut = ListManager(container: mockPersistantContainer)
  }
  
  override func tearDown() {
    sut = nil
    flushData()
    
    super.tearDown()
  }
  
  func test_GetLists() {
    
    // given
    _ = insertList(name: "1")
    _ = insertList(name: "2")
    _ = insertList(name: "3")
    _ = insertList(name: "4")
    _ = insertList(name: "5")

    // when
    let lists = sut.getLists()
    
    // then
    XCTAssertEqual(lists.count, 5)

  }
  
  func test_AddList() {
    // given
    _ = insertList(name: "1")
    _ = insertList(name: "2")
    _ = insertList(name: "3")
    _ = insertList(name: "4")
    _ = insertList(name: "5")
    
    // when
    _ = sut.addList(name: "6", description: nil)
    
    // then
    let lists = sut.getLists()
    XCTAssertEqual(lists.count, 6)
  }
  
//  func test_getTasks() {
//    // given
//    _ = insertTask(description: "1", list_id: "123")
//    _ = insertTask(description: "2", list_id: "123")
//    _ = insertTask(description: "3", list_id: "123")
//
//    // when
//    let tasks = sut.getTasks(list_id: "123")
//
//    // then
//    XCTAssertEqual(tasks.count, 3)
//  }
//
//  func test_addTask() {
//    // given
//    _ = insertTask(description: "1", list_id: "123")
//    _ = insertTask(description: "2", list_id: "123")
//    _ = insertTask(description: "3", list_id: "123")
//
//    // when
//    _ = sut.addTask(description: "4", list_id: "123")
//
//    // then
//    let tasks = sut.getTasks(list_id: "123")
//    XCTAssertEqual(tasks.count, 4)
//  }
  
  // stub functions
  func insertList( name: String ) -> List? {
    let obj = NSEntityDescription.insertNewObject(forEntityName: "List", into: mockPersistantContainer.viewContext)

    obj.setValue(name, forKey: "list_name")
    
    do {
        try mockPersistantContainer.viewContext.save()
    }  catch {
        print("create fakes error \(error)")
    }

    return obj as? List
  }
  
//  func insertTask( description: String, list_id: String ) -> Task? {
//    let obj = NSEntityDescription.insertNewObject(forEntityName: "Task", into: mockPersistantContainer.viewContext)
//
//    obj.setValue(description, forKey: "task_description")
//    obj.setValue(list_id, forKey: "list_id")
//    
//    do {
//        try mockPersistantContainer.viewContext.save()
//    }  catch {
//        print("create fakes error \(error)")
//    }
//
//    return obj as? Task
//  }
  
  func flushData() {
          
      let fetchRequestList:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
      let lists = try! mockPersistantContainer.viewContext.fetch(fetchRequestList)
      for case let obj as NSManagedObject in lists {
          mockPersistantContainer.viewContext.delete(obj)
      }
    
    let fetchRequestTask:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    let tasks = try! mockPersistantContainer.viewContext.fetch(fetchRequestTask)
    for case let obj as NSManagedObject in tasks {
        mockPersistantContainer.viewContext.delete(obj)
    }
    
      try! mockPersistantContainer.viewContext.save()

  }
  
  lazy var mockPersistantContainer: NSPersistentContainer = {
      
      let container = NSPersistentContainer(name: "FamHub", managedObjectModel: self.managedObjectModel)
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      description.shouldAddStoreAsynchronously = false // Make it simpler in test env
      
      container.persistentStoreDescriptions = [description]
      container.loadPersistentStores { (description, error) in
          // Check if the data store is in memory
          precondition( description.type == NSInMemoryStoreType )
                                      
          // Check if creating container wrong
          if let error = error {
              fatalError("Create an in-mem coordinator failed \(error)")
          }
      }
      return container
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
      let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
      return managedObjectModel
  }()
}
