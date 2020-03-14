//
//  TaskCellView.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class TaskCellView: UITableViewCell {
  
  
  @IBOutlet weak var imageView_Checkbox: UIImageView!
  @IBOutlet weak var label_description: UILabel!
  
  var taskViewModel: TaskViewModel! {
    didSet {
      
      let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskViewModel.description)
      
      if taskViewModel.completed == true {
      attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        imageView_Checkbox.image = UIImage(named: "checkbox_Checked")
        
          
        
      } else {
      attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        
        imageView_Checkbox.image = UIImage(named: "checkbox")
        
      }
      
      label_description.attributedText = attributeString
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
