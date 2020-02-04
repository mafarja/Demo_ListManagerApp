//
//  TaskCellView.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class TaskCellView: UITableViewCell {
  @IBOutlet weak var label_description: UILabel!
  
  var taskViewModel: TaskViewModel! {
    didSet {
      
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskViewModel.description)
      
      if taskViewModel.completed == true {
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
      } else {
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
      }
      
      label_description.attributedText = attributeString
    }
  }
}
