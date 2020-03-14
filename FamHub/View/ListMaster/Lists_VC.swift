//
//  ViewController.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/6/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import Floaty

class Lists_VC: UITableViewController {
  
  let listMasterViewModel = ListMasterViewModel()
  var selectedList: ListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
    configActionButton()
    registerModelObservers()
    
    self.navigationItem.rightBarButtonItem = editButtonItem
  }
  
  func configUI() {
    self.title = "StackList"
   // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
  }
  
  func configActionButton() {
    let floaty = Floaty()
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    floaty.addGestureRecognizer(tap)
    floaty.sticky = true
    floaty.buttonColor = UIColor.systemBlue
    //floaty.buttonColor = UIColor(red: 248.0/255.0, green: 47.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    self.view.addSubview(floaty)
  }
  
  private func registerModelObservers() {
    ListMasterViewModel.listViewModels.addObserver(self) { listViewModels, change in
       
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    
     
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    self.performSegue(withIdentifier: "showAddListModal", sender: self)
  }
    
  @objc func editTapped(_ sender: UITapGestureRecognizer) {
    self.performSegue(withIdentifier: "showAddListModal", sender: self)
  }
    
    
  
  @IBAction func unwindToLists(segue:UIStoryboardSegue) {
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showListDetail" {
      let controller = segue.destination as! ListDetail_VC
      controller.listViewModel = self.selectedList
      
      // get rid of the button button title
      let backItem = UIBarButtonItem()
      backItem.title = ""
      navigationItem.backBarButtonItem = backItem
    }
  }
}

//MARK: Drag&Drop and Delete
extension Lists_VC {
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
    let listToMove = ListMasterViewModel.listViewModels.value[sourceIndexPath.row]
    
    self.listMasterViewModel.moveList(listViewModel: listToMove, removeAtIndex: sourceIndexPath.row, insertAtIndex: destinationIndexPath.row)
    
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
     
      listMasterViewModel.archive(list_id: ListMasterViewModel.listViewModels.value[indexPath.row].id)
      
      
    }
  }
  
}

extension Lists_VC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ListMasterViewModel.listViewModels.value.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCellView
    cell.listViewModel =  ListMasterViewModel.listViewModels.value[indexPath.row]
    
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedList = ListMasterViewModel.listViewModels.value[indexPath.row]
    self.performSegue(withIdentifier: "showListDetail", sender: self)
  }
  
  
}
