////
////  ListManagerTests.swift
////  FamHubTests
////
////  Created by Marcelo Farjalla on 9/18/19.
////  Copyright © 2019 StackRank, LLC. All rights reserved.
////
//
import XCTest
@testable import StackList


class ListManagerTests: XCTestCase {
  
  var sut: ListManager!
  var repository: ListRepositoryMock!
  
  override func setUp() {
    super.setUp()
    
    repository = ListRepositoryMock()
    sut = ListManager(repository: repository)
    ListManager.lists.value = []
  }
  
  override func tearDown() {
    repository = nil
    sut = nil
    
    super.tearDown()
  }
  
  func testListManager_getLists() {

    // given
    _ = insertList(name: "1")
    _ = insertList(name: "2")
    _ = insertList(name: "3")
    _ = insertList(name: "4")
    _ = insertList(name: "5")

    // when
    let lists = sut.getLists()

    // then
    XCTAssertEqual(ListManager.lists.value.count, 5)

  }
  
  func testListManager_whenAddList_listsAddedToListsValue() {

    // given
    let promise = expectation(description: "List added")

    // when
    sut.addList(name: "test", description: "test") { (list) in

    }
    sut.addList(name: "test", description: "test") { (list) in
      promise.fulfill()
    }

    // then

    wait(for: [promise], timeout: 5)

    XCTAssertEqual(ListManager.lists.value.count, 2)

  }
  
  func testListManager_archiveList_listIsArchivedEqualsTrue() {
    
    // given
    _ = insertList(name: "1")
    let listToArchive = repository.dataArr[0]
    
    // when
    sut.getLists()
    sut.archive(list_id: listToArchive.id)
    
    // then
    XCTAssertTrue(ListManager.lists.value[0].isArchived == true)
    
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
//
  // stub functions
  func insertList( name: String ) {
    repository.dataArr.append(List(id: "123", name: name, user_id: "123", description: nil, created: Date(), date_modified: Date(), isArchived: false, tasks: nil))
  }
//
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
//
//  func flushData() {
//
//
//
//  }
//
//
  
//  let fetchRequestList:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
//  let lists = try! mockPersistantContainer.viewContext.fetch(fetchRequestList)
//  for case let obj as NSManagedObject in lists {
//      mockPersistantContainer.viewContext.delete(obj)
//  }
//
//  let fetchRequestTask:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//  let tasks = try! mockPersistantContainer.viewContext.fetch(fetchRequestTask)
//  for case let obj as NSManagedObject in tasks {
//      mockPersistantContainer.viewContext.delete(obj)
//  }
//
//    try! mockPersistantContainer.viewContext.save()

  
}
