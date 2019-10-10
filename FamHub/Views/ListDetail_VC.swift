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
  let listManager = ListManager()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField_taskDescription: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ListManager.delegate = self
    configUI()
  }
  
  func configUI() {
    self.title = self.list?.list_name
  }
  
  func createTask() {
    guard let description = self.textField_taskDescription.text,
      description.count > 0,
      let list_id = self.list?.id else {
      return
    }
    
    _ = self.listManager.addTask(description: description, list_id: list_id)
    
    self.textField_taskDescription.text = ""
  }
}

extension ListDetail_VC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let list_id = self.list?.id else {
      print("Error: List has not been set")
      fatalError("List has not been set")
    }
    return self.listManager.getTasks(list_id: list_id).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCellView
    if let list_id = self.list?.id {
      cell.label_description.text = self.listManager.getTasks(list_id: list_id)[indexPath.row].task_description
    }
    return cell
  }
}

extension ListDetail_VC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    createTask()
    return true
  }
}

extension ListDetail_VC: ListManagerDelegate {
  func didUpdateData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
