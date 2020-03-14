//
//  ListRepositoryMock.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 2/6/20.
//  Copyright © 2020 StackRank, LLC. All rights reserved.
//

import Foundation



class ListRepositoryMock: ListRepository {
  
  
  var dataArr = [List]()
  
  override func getAll( identifier:String? ) -> [List] {
    
    return dataArr
    
  }
  
  override func get( identifier:Int ) -> List? {
    
    return List(id: "123", name: "123", user_id: "123", description: "123", created: Date(), date_modified: Date(), isArchived: false, tasks: nil)
  }
  
  override func create( a: List ) -> Bool {
    
    dataArr.append(a)
    
    return true
  }
  
  override func update( a: List ) -> Bool {
    
    return true
  }
  
  override func delete( a: List ) -> Bool {
    
    return true
  }
  
}
