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
  
  var listViewModels: [ListViewModel] = []
  
  let listManager = ListManager()
  var selectedList: ListViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    configActionButton()
    fetchLists()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    ListManager.delegate = self
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
  
  func fetchLists() {
    let lists = self.listManager.getLists()
    
    self.listViewModels = lists.map({
      return ListViewModel(list: $0)
    })
    self.tableView.reloadData()
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    self.performSegue(withIdentifier: "showAddListModal", sender: self)
  }
  
  @IBAction func unwindToLists(segue:UIStoryboardSegue) {
    
  }
}

extension Lists_VC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCellView
    cell.listViewModel =  self.listViewModels[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedList = self.listViewModels[indexPath.row]
    self.performSegue(withIdentifier: "showListDetail", sender: self)
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

extension Lists_VC: ListManagerDelegate {
  func didUpdateData() {
    DispatchQueue.main.async {
      self.fetchLists()
      self.tableView.reloadData()
    }
  }
}
