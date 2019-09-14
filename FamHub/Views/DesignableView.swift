//
//  DesignableView.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/11/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
}
