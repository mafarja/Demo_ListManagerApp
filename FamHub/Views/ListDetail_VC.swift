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
  let listManager = ListManager()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField_taskDescription: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ListManager.delegate = self
    configUI()
    getTasks()
  }
  
  func configUI() {
    self.title = self.list?.name
  }
  
  func getTasks() {
    guard let list = self.list else {
      return
    }
    self.listManager.getTasks(list: list) {
      (tasks, error) in
      guard let tasks = tasks,
        error == nil else {
          print(error)
          return
      }
      self.tasks = tasks.reversed()
    
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  func createTask() {
    guard let description = self.textField_taskDescription.text,
      description.count > 0,
      let list = self.list else {
      return
    }
    self.listManager.addTask(list: list, description: description) {
      (error) in
      if error != nil {
        print(error)
      }
      DispatchQueue.main.async {
        self.textField_taskDescription.text = ""
      }
    }
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

extension ListDetail_VC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    createTask()
    return true
  }
}

extension ListDetail_VC: ListManagerDelegate {
  func didAddTask(task: Task, sender: ListManager) {
    self.tasks.insert(task, at: 0)
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
