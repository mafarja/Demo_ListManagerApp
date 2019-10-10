//
//  Utils.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/30/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

class Utils {
  func objectId() -> String {
    let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
    let machine = String(arc4random_uniform(900000) + 100000)
    let pid = String(arc4random_uniform(9000) + 1000)
    let counter = String(arc4random_uniform(900000) + 100000)
    return time + machine + pid + counter
  }
}


