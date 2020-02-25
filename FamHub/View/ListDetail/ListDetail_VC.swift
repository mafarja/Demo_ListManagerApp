//
//  ListDetail_VC.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

class ListDetail_VC: UIViewController {
  
  var listViewModel: ListViewModel?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField_taskDescription: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.listViewModel?.delegate = self
    configUI()
    
    self.tableView.isEditing = true
 
  }
  
  func configUI() {
    self.title = self.listViewModel?.name
  }
  
  
  func addTask() {

    guard let description = self.textField_taskDescription.text,
      description.count > 0,
      let listViewModel = self.listViewModel else {
      return
    }

    _ = listViewModel.addTask(description: description)

    self.textField_taskDescription.text = ""
  }

}

extension ListDetail_VC {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let listViewModel = self.listViewModel {
            let taskToMove = listViewModel.taskViewModels[sourceIndexPath.row]
            listViewModel.taskViewModels.remove(at: sourceIndexPath.row)
            
            listViewModel.taskViewModels.insert(taskToMove, at: destinationIndexPath.row)
        }
        
    }
}


extension ListDetail_VC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let listViewModel = self.listViewModel else {
      print("Error: List has not been set")
      fatalError("List has not been set")
    }
    return listViewModel.taskViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let listViewModel = self.listViewModel  else {
       print("Error: List has not been set")
       fatalError("List has not been set")
     }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCellView
    
    cell.taskViewModel = listViewModel.taskViewModels[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    guard let listViewModel = self.listViewModel  else { return [] }
  
    var complete = UITableViewRowAction(style: .normal, title: "Complete") {
      (action, indexPath) in
      
      listViewModel.markTaskCompleted(task_id: listViewModel.taskViewModels[indexPath.row].id)
      
    }
    
    if (listViewModel.taskViewModels[indexPath.row].completed == true) {
      complete = UITableViewRowAction(style: .normal, title: "Undo") {
        (action, indexPath) in
        listViewModel.undoTaskCompleted(task_id: listViewModel.taskViewModels[indexPath.row].id)
      }
    }
    
    return [complete]
  }
}

extension ListDetail_VC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    addTask()
    return true
  }
}

extension ListDetail_VC: ListViewModelDelegate {
  func didUpdate() {
    self.tableView.reloadData()
  }
}
