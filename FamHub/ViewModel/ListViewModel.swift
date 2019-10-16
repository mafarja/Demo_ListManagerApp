//
//  ListViewModel.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct ListViewModel {
  let id: String
  let name: String
  let description: String
  
  init(list: List) {
    self.id = list.id ?? ""
    self.name = list.list_name ?? ""
    self.description = list.list_description ?? ""
  }
}
