//
//  ListManagerTests.swift
//  FamHubTests
//
//  Created by Marcelo Farjalla on 9/18/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import XCTest
@testable import FamHub

class ListManagerTests: XCTestCase {
  var sut: ListManager?
  
  override func setUp() {
    super.setUp()
    
    sut = ListManager(service: ServiceMock())
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testGetListsCompletesWithListsArray() {
    // given
    let jsonObj = [
      [
        "_id":"5d7820be850fb20811718b14",
        "name":"Chores",
        "description":"Take the trash out",
        "created":"2019-09-10T22:16:30.321Z",
        "__v":0
      ],
      [
        "_id":"5d78220e850fb20811718b15",
        "name":"Chores",
        "description":"Take the trash out",
        "created":"2019-09-10T22:22:06.017Z",
        "__v":0
      ]
    ] as [[String: Any]]
  
    let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
    (sut!.service as! ServiceMock).data = jsonData
    let promise = expectation(description: "Array of List objects retreived.")
    
    // when
    sut?.getLists(completion: { (lists, error) in
      
      guard let lists = lists,
        error == nil else {
          XCTFail("Error getLists: \(error!.localizedDescription)")
          return
      }
      
      
      // then
      if lists.count == 2 {
        
        promise.fulfill()
      }
    })
    wait(for: [promise], timeout: 5)
  }
  
  func testAddListCompletesWithNoError() {
    // given
    let listObj = [
        "_id":"5d7820be850fb20811718b14",
        "name":"Chores",
        "description":"Take the trash out",
        "created":"2019-09-10T22:16:30.321Z",
        "__v":0
    ] as [String: Any]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: listObj, options: [])
    (sut!.service as! ServiceMock).data = jsonData
    let promise = expectation(description: "List was added successfully")
    let list = List(_id: nil, name: "Chores", description: "Take the trash out.", status: nil, created: nil)
    
    // when
    sut?.add(list: list, completion: { (error) in
      // then
      if error == nil {
        promise.fulfill()
      }
    })
    
    wait(for: [promise], timeout: 5)
  }
  
  func testAddTaskCompletesWithNoErrors() {
    // given
    let returnData = [
      "_id":"5d7820be850fb20811718b14",
      "description":"Take the trash out",
      "created":"2019-09-10T22:16:30.321Z",
      "list_id":"5d7820be850fb20811718b14",
      "__v":0
      ] as [String: Any]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: returnData, options: [])
    (sut!.service as! ServiceMock).data = jsonData
    let promise = expectation(description: "Task was added successfully")
    let task = Task(_id: nil, description: "Take the trash out", status: nil, posted: nil, list_id: "5d7820be850fb20811718b14")
    
    // when
    sut?.add(task: task, completion: { (error) in
      // then
      if error == nil {
        promise.fulfill()
      }
    })
    
    wait(for: [promise], timeout: 5)
    
  }
  
  func testGetTasksCompletesWithArrayOfTasks() {
    // given
    let jsonObj = [
      [
        "_id":"5d7820be850fb20811718b14",
        "description":"Take the trash out",
        "posted":"2019-09-10T22:16:30.321Z",
        "list_id":"5d7820be850fb20811718b14",
        "__v":0
      ],
      [
        "_id":"5d7820be850fb20811718b14",
        "description":"Take the trash out",
        "posted":"2019-09-10T22:16:30.321Z",
        "list_id":"5d7820be850fb20811718b14",
        "__v":0
      ]
    ] as [[String: Any]]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
    (sut!.service as! ServiceMock).data = jsonData
    let promise = expectation(description: "Array of task objects retreived.")
    
    // when
    sut?.getTasks(list_id: "5d7820be850fb20811718b14" , completion: { (tasks, error) in
      
      guard let tasks = tasks,
        error == nil else {
          XCTFail("Error getLists: \(error!.localizedDescription)")
          return
      }
      
      
      // then
      if tasks.count == 2 {
        
        promise.fulfill()
      }
    })
    wait(for: [promise], timeout: 5)
  }
  
  
  
  
}
