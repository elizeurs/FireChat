//
//  NewMessageController.swift
//  FireChat
//
//  Created by Elizeu RS on 29/09/21.
//

import UIKit

class NewMessageController: UITableViewController {
  
  private let reuseIdentifier = "UserCell"
  
  // MARK: - Properties
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Selector
  
  @objc func handleDismissal() {
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - Helpers
  
  func configureUI() {
    configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
    
    tableView.tableFooterView = UIView()
    tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.rowHeight = 80
    
//    view.backgroundColor = .systemPink
  }
}


// MARK: - UITableViewDataSource

extension NewMessageController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
    return cell
  }
}
