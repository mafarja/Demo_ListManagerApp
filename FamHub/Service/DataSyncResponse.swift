//
//  DataSyncResponse.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 10/2/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

struct DataSyncResponse: Codable {
  let lists: [List]
  let tasks: [Task]
}


