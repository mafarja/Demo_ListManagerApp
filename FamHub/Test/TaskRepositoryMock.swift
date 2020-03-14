//
//  TaskRepositoryMock.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 3/4/20.
//  Copyright © 2020 StackRank, LLC. All rights reserved.


import Foundation
import CoreData

class TaskRepositoryMock: TaskRepository {
  
  var dataArr = [Task]()
  
    override func getAll(identifier: String?) -> [Task] {
    
    return dataArr
  }
  
    override func get(identifier: Int) -> Task? {
    
    return Task(id: "213", description: "123", list_id: "123", completed: false, posted: Date(), order: 0, deleted: false, date_modified: Date())
  }
  
    override func create(a: Task) -> Bool {
    
        dataArr.append(a)
    
        return true
    }
  
    override func update(a: Task) -> Bool {
    
        for task in dataArr {
            if (task.id == a.id) {
                task.completed = a.completed
                task.date_modified = a.date_modified
                task.deleted = a.deleted
                task.description = a.description
                task.list_id = a.list_id
                task.order = a.order
                task.posted = a.posted
            }
                
        }
    
        return true

    }
  
    override func delete(a: Task) -> Bool {
    
   
    
        return true

    }
  
  
}

