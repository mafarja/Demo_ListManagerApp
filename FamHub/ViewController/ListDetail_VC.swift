//
//  ListDetail_VC.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class ListDetail_VC: UIViewController {
  
  var taskViewModels: [TaskViewModel] = []
  var listViewModel: ListViewModel?
  let listManager = ListManager()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField_taskDescription: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ListManager.delegate = self
    configUI()
    fetchTasks()
    tableView.reloadData()
  }
  
  func configUI() {
    self.title = self.listViewModel?.name
  }
  
  func fetchTasks() {
    let tasks = self.listManager.getTasks(list_id: listViewModel!.id)
    self.taskViewModels = tasks.map({
      return TaskViewModel(task: $0)
    })
    self.tableView.reloadData()
  }
  
  func createTask() {
    guard let description = self.textField_taskDescription.text,
      description.count > 0,
      let list_id = self.listViewModel?.id else {
      return
    }
    
    _ = self.listManager.addTask(description: description, list_id: list_id)
    
    self.textField_taskDescription.text = ""
  }
}

extension ListDetail_VC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let list_id = self.listViewModel?.id else {
      print("Error: List has not been set")
      fatalError("List has not been set")
    }
    return self.taskViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCellView
    if let list_id = self.listViewModel?.id {
      cell.taskViewModel = self.taskViewModels[indexPath.row]
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
      self.fetchTasks()
      self.tableView.reloadData()
    }
  }
}
