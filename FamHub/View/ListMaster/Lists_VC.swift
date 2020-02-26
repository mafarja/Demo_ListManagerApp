//
//  ViewController.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/6/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit
import Floaty

class Lists_VC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let listMasterViewModel = ListMasterViewModel()
  var selectedList: ListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configUI()
    configActionButton()
    registerModelObservers()
  }
  
  func configUI() {
    self.title = "List Maker"
  }
  
  func configActionButton() {
    let floaty = Floaty()
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    floaty.addGestureRecognizer(tap)
    self.view.addSubview(floaty)
  }
  
  private func registerModelObservers() {
    listMasterViewModel.listViewModels.addObserver(self, options: [.initial, .new]) { listViewModels, change in
       
      DispatchQueue.main.async {
              self.tableView.reloadData()

      }
    }
     
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
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

extension Lists_VC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listMasterViewModel.listViewModels.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCellView
    cell.listViewModel =  self.listMasterViewModel.listViewModels.value[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedList = self.listMasterViewModel.listViewModels.value[indexPath.row]
    self.performSegue(withIdentifier: "showListDetail", sender: self)
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
    self.selectedList = self.listMasterViewModel.listViewModels.value[indexPath.row]
     
     var complete = UITableViewRowAction(style: .normal, title: "Archive") {
       (action, indexPath) in
      
      guard let selectedList = self.selectedList else { return }
      self.listMasterViewModel.archive(list_id: selectedList.id)
    }
     
     return [complete]
   }
}
