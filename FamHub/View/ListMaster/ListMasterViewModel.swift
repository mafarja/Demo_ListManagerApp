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
  static var listViewModels: Observable<[ListViewModel]> = Observable<[ListViewModel]>([])
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
    
    var listViewModelsArr: [ListViewModel] = []
    for list in lists {
      listViewModelsArr.append(ListViewModel(list: list))
    }
    
    let listViewModelsArrFiltered = listViewModelsArr.filter {
      $0.isArchived == false
    }
    
    ListMasterViewModel.listViewModels.value = listViewModelsArrFiltered
  
  }
  
  func archive(list_id: String) {
    self.listManager.archive(list_id: list_id)
  }
  
  func moveList(listViewModel: ListViewModel, removeAtIndex: Int, insertAtIndex: Int) {
    
    ListMasterViewModel.listViewModels.value.remove(at: removeAtIndex)
    ListMasterViewModel.listViewModels.value.insert(listViewModel, at: insertAtIndex)
    
  }
  
}
