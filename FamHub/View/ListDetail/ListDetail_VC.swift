//
//  ListDetail_VC.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/12/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

class ListDetail_VC: UITableViewController {
  
  var listViewModel: ListViewModel?
  
  @IBOutlet weak var textField_taskDescription: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.listViewModel?.delegate = self
    configUI()
    registerModelObservers()
    
    textField_taskDescription.delegate = self
    
    self.navigationItem.rightBarButtonItem = editButtonItem
 
 
  }
  
  func configUI() {
    self.title = self.listViewModel?.name
  }
  
  private func registerModelObservers() {
    listViewModel?.isEditMode.addObserver(self, options: [.initial, .new]) { bool, change in
      
      //self.configEditModeUI()
      
    }
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
  
  
  @IBAction func onCheckboxTapped(_ sender: Any) {
    
    let tap = sender as! UITapGestureRecognizer
    let imgView = tap.view as! UIImageView
    let index = imgView.tag
    
    guard let listViewModel = self.listViewModel else { return }
    
    if listViewModel.taskViewModels[index].completed {
      listViewModel.undoTaskCompleted(task_id: listViewModel.taskViewModels[index].id)
    } else {
      listViewModel.markTaskCompleted(task_id: listViewModel.taskViewModels[index].id)
    }
    
  }
  
}

// drag and drop
extension ListDetail_VC {
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
  }
    
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let listViewModel = self.listViewModel {
            let taskToMove = listViewModel.taskViewModels[sourceIndexPath.row]
          
          listViewModel.moveTask(taskViewModel: taskToMove, removeAtIndex: sourceIndexPath.row, insertAtIndex: destinationIndexPath.row)
          
          tableView.reloadData()
          
        }
        
    }
}


extension ListDetail_VC  {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let listViewModel = self.listViewModel else {
      print("Error: List has not been set")
      fatalError("List has not been set")
    }
    return listViewModel.taskViewModels.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let listViewModel = self.listViewModel  else {
       print("Error: List has not been set")
       fatalError("List has not been set")
     }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCellView
    
    cell.taskViewModel = listViewModel.taskViewModels[indexPath.row]
    
    cell.imageView_Checkbox.tag = indexPath.row
    cell.imageView_Checkbox.isUserInteractionEnabled = true
    
    let tapped = UITapGestureRecognizer(target: self, action: #selector(onCheckboxTapped(_:)))
    tapped.numberOfTouchesRequired = 1
    cell.imageView_Checkbox.addGestureRecognizer(tapped)
    
    
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
//  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//    guard let listViewModel = self.listViewModel  else { return [] }
//  
//    var complete = UITableViewRowAction(style: .destructive, title: "Delete") {
//      (action, indexPath) in
//      
//      listViewModel.markTaskCompleted(task_id: listViewModel.taskViewModels[indexPath.row].id)
//      
//    }
//    
//    if (listViewModel.taskViewModels[indexPath.row].completed == true) {
//      complete = UITableViewRowAction(style: .normal, title: "Undo") {
//        (action, indexPath) in
//        listViewModel.undoTaskCompleted(task_id: listViewModel.taskViewModels[indexPath.row].id)
//      }
//    }
//    
//    return [complete]
//  }
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
    tableView.reloadData()
  }
}

extension ListDetail_VC {
  
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let listViewModel = self.listViewModel  else {
        print("Error: List has not been set")
        fatalError("List has not been set")
      }
      listViewModel.delete(task: listViewModel.taskViewModels[indexPath.row])
      
      
    }
  }
  
}
