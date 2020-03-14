//
//  ListTests.swift
//  FamHubTests
//
//  Created by Marcelo Farjalla on 3/4/20.
//  Copyright © 2020 StackRank, LLC. All rights reserved.
//

import XCTest
@testable import StackList

class ListTests: XCTestCase {
    
    
    
    var sut: List!
    var taskRepo: TaskRepositoryMock!
    var listRepo: ListRepositoryMock!
    
    override func setUp() {
        super.setUp()
        
        sut = List(id: "123", name: "Test List", user_id: "123", description: nil, created: Date(), date_modified: Date(), isArchived: false, tasks: nil)
        
        self.taskRepo = TaskRepositoryMock()
        self.listRepo = ListRepositoryMock()
        
        sut.taskRepo = self.taskRepo
        sut.listRepo = self.listRepo
        
    }

    override func tearDown() {
        sut = nil
        taskRepo = nil
        listRepo = nil
        
    }
    
    func testList_getTasks() {
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        // when
        let returnedTasks = sut.getTasks()
        
        // then
        XCTAssertEqual(returnedTasks.count, 2)
    }
    
    func testList_addTask_taskAddedToTasksValue() {
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        // when
        sut.addTask(description: "new task")
        
        // then
        XCTAssertEqual(sut.tasks.value.count, 3)
    }
    
    func testList_updateTasks_tasksUpdatedInTasksValue() {
        
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        let tasksToBeUpdated = taskRepo.getAll(identifier: "123")
        
        var tasksToBeUpdated_viewModels = tasksToBeUpdated.map { TaskViewModel(task: $0) }
        
        // when
        tasksToBeUpdated_viewModels[0].completed = true
        sut.updateTasks(taskViewModels: tasksToBeUpdated_viewModels)
        
        // then
        func arraysAreTheSame() -> Bool {
            
            let originalTasksArr = tasksToBeUpdated_viewModels.map {
                Task(id: $0.id, description: $0.description, list_id: $0.description, completed: $0.completed, posted: $0.posted, order: $0.order, deleted: $0.deleted, date_modified: $0.date_modified)
            }
            
            for taskA in originalTasksArr {
                for taskB in sut.tasks.value {
                    
                    if (taskA.id == taskB.id) {
                        guard taskA.completed == taskB.completed else {
                            return false
                        }
                    }
                }
            }
            return true
        }
        
        XCTAssertTrue(arraysAreTheSame())
        
    }
    
    func testList_markTaskCompleted_taskIsCompletedTrue() {
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        sut.tasks.value = sut.getTasks()
        
        let taskToBeCompleted = taskRepo.getAll(identifier: "123")[0]
        
        
        // when
        sut.markTaskCompleted(task_id: taskToBeCompleted.id)
        
        // then
        let updatedTask = sut.tasks.value.first(where: { $0.id == taskToBeCompleted.id })
        
        
        XCTAssertEqual(updatedTask?.completed, true)
    }
    
    func testList_undoTaskCompleted_taskIsCompletedFalse() {
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        sut.tasks.value = sut.getTasks()
        
        let taskToBeUnCompleted = taskRepo.getAll(identifier: "123")[0]
        
        // when
        sut.undoTaskCompleted(task_id: taskToBeUnCompleted.id)
        
        // then
        let updatedTask = sut.tasks.value.first(where: { $0.id == taskToBeUnCompleted.id })
        
        
        XCTAssertEqual(updatedTask?.completed, false)
    }
    
    func testList_deleteTask_taskIsDeletedTrue() {
        // given
        _ = insertTask(description: "Test Task", list_id: "123")
        _ = insertTask(description: "Test Task", list_id: "123")
        
        sut.tasks.value = sut.getTasks()
        
        let taskToBeDeleted = taskRepo.getAll(identifier: "123")[0]
        
        // when
        sut.delete(task: taskToBeDeleted)
        
        // then
        let updatedTask = sut.tasks.value.first(where: { $0.id == taskToBeDeleted.id })
        
        XCTAssertEqual(updatedTask?.deleted, true)
        
    }
    
    
    
    // test helpers
    
    var orderIndex = 0
    func insertTask( description: String, list_id: String ) -> Task? {
        
        let randomId = UUID().uuidString
        
        let task = Task(id: randomId, description: description, list_id: list_id, completed: false, posted: Date(), order: orderIndex, deleted: false, date_modified: Date())
        
        taskRepo.dataArr.append(task)
        orderIndex += 1
        return task
        
    }


}
