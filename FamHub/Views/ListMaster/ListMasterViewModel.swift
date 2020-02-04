//
//  ListMasterViewModel.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 11/21/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol ListMasterViewModelDelegate {
  func didUpdate()
}

class ListMasterViewModel {
  
  let listManager = ListManager()
  var title: String = ""
  var listViewModels: Observable<[ListViewModel]> = Observable<[ListViewModel]>([])
  var showArchived: Bool = false
  
  init() {
    
    registerModelObservers()
    registerDidCompleteDataSyncNotificationObserver()
    callListManagerGetLists()
    
  }
  
  private func registerModelObservers() {
    ListManager.lists.addObserver(self, options: [.initial, .new]) { lists, change in
      
      self.loadListViewModels(lists: lists)
      
    }
  }
  
  private func registerDidCompleteDataSyncNotificationObserver() {
    NotificationCenter.default.addObserver(
    self,
    selector: #selector(self.callListManagerGetLists),
    name: .didCompleteDataSync,
    object: nil)
  }
  
  @objc private func callListManagerGetLists() {
    _ = listManager.getLists()
  }
  
  private func loadListViewModels( lists: [List]) {
    
    
    
    
    outer: for list in lists.reversed() {
      for (index, model) in self.listViewModels.value.enumerated().reversed() {
        if list.id == model.id {
          
            model.name = list.name
            model.description = list.description ?? ""
            model.isArchived = list.isArchived
          
          if model.isArchived == true {
            self.listViewModels.value.remove(at: index)
          }
          continue outer
        }
      }
      if list.isArchived == false {
        self.listViewModels.value.insert(ListViewModel(list: list), at: 0)
      }
      
    }
  
  }
  
  func archive(list_id: String) {
    self.listManager.archive(list_id: list_id)
  }
}
