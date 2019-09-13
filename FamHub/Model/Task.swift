//
//  Response.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct Task: Decodable {
  let _id: String
  let description: String
  let status: String?
  let posted: String
  let list: String
}
