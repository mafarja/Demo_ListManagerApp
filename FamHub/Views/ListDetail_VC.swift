//
//  ListDetail_VC.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class ListDetail_VC: UIViewController {
  
  var list: List?
  var tasks = [Task]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
  }
  
  func configUI() {
    self.title = self.list?.name
   
  }
}

extension ListDetail_VC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCellView
    
    cell.label_description.text = self.tasks[indexPath.row].description
    
    return cell
  }
  
  
}
