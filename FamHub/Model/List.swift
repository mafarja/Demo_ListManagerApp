//
//  List.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/9/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct List: Decodable {
  let _id: String?
  let name: String
  let description: String?
  let status: String?
  let created: String?
}
