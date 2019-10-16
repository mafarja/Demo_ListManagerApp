//
//  DataSyncTests.swift
//  FamHubTests
//
//  Created by Marcelo Farjalla on 10/13/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import XCTest
import CoreData
@testable import FamHub

class DataSyncTests: XCTestCase {
  
  var sut: DataSync!

  override func setUp() {
    super.setUp()
    
    let service = FHServiceMock()
    sut = DataSync(container: mockPersistantContainer, service: service)
  }

  override func tearDown() {
    sut = nil
    flushData()
    
    super.tearDown()
  }

  func testSync() {
    // given
    
    var lists = [Any]()
    var tasks = [Any]()
    
    // init remoteData
    let remoteData = [
      "lists": [
        [
          "_id": "5d9ec9de5506947725497855",
          "created": "2019-10-09T18:04:14.000Z",
          "date_modified": "2019-10-09T18:04:14.000Z",
          "description": nil,
          "name": "One list",
          "status": nil
        ]
      ],
      "tasks": [
        [
          "_id": "5d9ec9f15582217841786461",
          "date_modified": "2019-10-09T18:04:33.000Z",
          "description": "One task",
          "list_id": "5d9ec9ec6017784593320098",
          "posted": "2019-10-09T18:04:33.000Z",
          "status" : nil
        ]
      ]
    ]
    
    (sut.service as! FHServiceMock).data = remoteData
    
    // init local data
    insertLocalList(name: "One")
    insertLocalList(name: "Two")
    insertLocalList(name: "Three")
    
    insertLocalTask(description: "One", list_id: "234")
    insertLocalTask(description: "Two", list_id: "234")
    insertLocalTask(description: "Three", list_id: "234")
    
    let promise = expectation(description: "Sync completed")
    
    
    // when
    sut.sync() { (error) in
      
      // then
      let fetchRequestList:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
      lists = try! self.backgroundContext.fetch(fetchRequestList)
          
      let fetchRequestTask:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
      tasks = try! self.backgroundContext.fetch(fetchRequestTask)
        
      
      promise.fulfill()
      
    }
    
    
    wait(for: [promise], timeout: 5)
    
    XCTAssertEqual(lists.count, 4)
    XCTAssertEqual(tasks.count, 4)
    
  }
  
  
  // stub functions
  func insertLocalList( name: String ) {
    let obj = NSEntityDescription.insertNewObject(forEntityName: "List", into: self.backgroundContext)
    
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    let dateString = "2019-10-09T18:04:33.000Z"
    let date = formatter.date(from: dateString)
    
    
    obj.setValue(date, forKey: "list_name")
    obj.setValue(date, forKey: "date_modified")
    
    do {
      try self.backgroundContext.save()
    }  catch {
        print("create fakes error \(error)")
    }
  }
  
  func insertLocalTask( description: String, list_id: String ) {
    let obj = NSEntityDescription.insertNewObject(forEntityName: "Task", into: self.backgroundContext)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    let now = formatter.date(from: Date().toString())

    obj.setValue(description, forKey: "task_description")
    obj.setValue(list_id, forKey: "list_id")
    obj.setValue(now, forKey: "date_modified")
    
    do {
      try self.backgroundContext.save()
    }  catch {
        print("create fakes error \(error)")
    }
  }
  
  func flushData() {
          
    let fetchRequestList:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
    let lists = try! self.backgroundContext.fetch(fetchRequestList)
      for case let obj as NSManagedObject in lists {
        self.backgroundContext.delete(obj)
      }
    
    let fetchRequestTask:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    let tasks = try! self.backgroundContext.fetch(fetchRequestTask)
    for case let obj as NSManagedObject in tasks {
      self.backgroundContext.delete(obj)
    }
    
    try! self.backgroundContext.save()

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
  
  lazy var backgroundContext: NSManagedObjectContext = {
    return self.mockPersistantContainer.newBackgroundContext()
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
      let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
      return managedObjectModel
  }()

}
