//
//  Dynamic.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class Dynamic<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  func bind(listener: Listener?) {
    self.listener = listener
  }
  
  func bindAndFire(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ v: T) {
    value = v
  }
}
