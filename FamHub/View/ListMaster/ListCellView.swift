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
  @IBOutlet weak var label_TaskCounter: UILabel!
  
  var listViewModel: ListViewModel! {
    didSet {
      label_listName.text = listViewModel.name
      
      label_TaskCounter.text = "\(listViewModel.numberTasksCompleted) / \(listViewModel.totalNumberOfTasks)"
      
    }
  }
  
  private var myReorderImage: UIImage? = nil

  override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)

      for subViewA in self.subviews {
          if (subViewA.classForCoder.description() == "UITableViewCellReorderControl") {
              for subViewB in subViewA.subviews {
                  if (subViewB.isKind(of: UIImageView.classForCoder())) {
                      let imageView = subViewB as! UIImageView;
                      if (self.myReorderImage == nil) {
                          let myImage = imageView.image;
                          myReorderImage = myImage?.withRenderingMode(.alwaysTemplate);
                      }
                      imageView.image = self.myReorderImage;
                    imageView.tintColor = .systemBlue;
                      break;
                  }
              }
              break;
          }
      }
  }
  
 
}
