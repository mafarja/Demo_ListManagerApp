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
  
  let listManager = ListManager()
  var selectedList: List?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    configActionButton()
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
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    self.performSegue(withIdentifier: "showAddListModal", sender: self)
  }
  
  @IBAction func unwindToLists(segue:UIStoryboardSegue) {
    
  }
}

extension Lists_VC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.listManager.getLists().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCellView
    cell.label_listName.text =  self.listManager.getLists()[indexPath.row].list_name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedList = self.listManager.getLists()[indexPath.row]
    self.performSegue(withIdentifier: "showListDetail", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showListDetail" {
      let controller = segue.destination as! ListDetail_VC
      controller.list = self.selectedList
      
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
      self.tableView.reloadData()
    }
  }
}
