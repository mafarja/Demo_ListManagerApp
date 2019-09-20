//
//  Service.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/19/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import Foundation

protocol Service {
  func sendHttpGetRequest(url: URL, completion: @escaping (Data?, Error?) -> Void)
  func sendHttpPostRequest(url: URL, params: [String: Any], completion: @escaping (Data?, Error?) -> Void)
}
