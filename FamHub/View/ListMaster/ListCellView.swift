//
//  ListCellView.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/11/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class ListCellView: UITableViewCell {
  @IBOutlet weak var label_listName: UILabel!
  
  var listViewModel: ListViewModel! {
    didSet {
      label_listName.text = listViewModel.name
    }
  }
}
