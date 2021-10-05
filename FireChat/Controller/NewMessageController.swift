//
//  NewMessageController.swift
//  FireChat
//
//  Created by Elizeu RS on 29/09/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: AnyObject {
  func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UITableViewController {
    
  // MARK: - Properties
  
  private var users = [User]()
  weak var delegate: NewMessageControllerDelegate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    fetchUsers()
  }
  
  // MARK: - Selector
  
  @objc func handleDismissal() {
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - API
  
  func fetchUsers() {
    Service.fetchUsers { users in
      self.users = users
      self.tableView.reloadData()
      
//      print("DEBUG: Users in new message controller \(users)")
    }
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
    return users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
    cell.user = users[indexPath.row]
    
    print("DEBUG: Index row is \(indexPath.row)")
    print("DEBUG: User in array is \(users[indexPath.row].username)")
    
    return cell
  }
}

extension NewMessageController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    
//    print("DEBUG: Selected user is \(users[indexPath.row].username)")
  }
}
