//
//  AddListModal_ViewController.swift
//  FamHub
//
//  Created by Marcelo Farjalla on 9/11/19.
//  Copyright © 2019 StackRank, LLC. All rights reserved.
//

import UIKit

class AddListModal_VC: UIViewController {
  let listManager = ListManager()
  @IBOutlet weak var textField_ListName: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onCreateListButton(_ sender: Any) {
    guard let name = textField_ListName.text,
      name.count != 0 else {
      return
    }
    self.createList()
  }
  
  @IBAction func dismissPopup(_ sender: Any) {
    self.performSegue(withIdentifier: "unwindToLists", sender: self)
  }
  
  func createList() {
    guard let name = self.textField_ListName.text else { return }
    self.listManager.createList(name: name) {
      (error) in
      if let error = error {
        print(error)
      }
      DispatchQueue.main.async {
        self.performSegue(withIdentifier: "unwindToLists", sender: self)
      }
    }
  }
}
