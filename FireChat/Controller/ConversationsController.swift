//
//  ConversationsController.swift
//  FireChat
//
//  Created by Elizeu RS on 22/09/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController {
  
  // MARK: - Properties
  
  private let tableview = UITableView()
  private var conversations = [Conversation]()
  
  private let newMessageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.backgroundColor = .systemPurple
    button.tintColor = .white
    button.imageView?.setDimensions(height: 24, width: 24)
    button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    authenticateUser()
    fetchConversations()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
  }
  
  
  // MARK: - Selectors
  
  @objc func showProfile() {
    logout()
//    print(123)
  }
  
  
  @objc func showNewMessage() {
    let controller = NewMessageController()
    controller.delegate = self
    let nav = UINavigationController(rootViewController: controller)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
//    print(123)
  }
  
  
  // MARK: - API
  
  func fetchConversations() {
    Service.fetchconversations { conversations in
      self.conversations = conversations
      self.tableview.reloadData()
    }
  }
  
  
  func authenticateUser() {
    if Auth.auth().currentUser?.uid == nil {
      presentLoginScreen()
//      print("DEBUG: User is not logged in. Present login screen here..")
    } else {
      print("DEBUG: User id is \(Auth.auth().currentUser?.uid)")
//      print("DEBUG: User is logged in. Configure controller..")
    }
  }
  
  
  func logout() {
    do {
      try Auth.auth().signOut()
      presentLoginScreen()
    } catch {
      print("DEBUG: Error signing out..")
    }
  }
  
  
  // MARK: - Helpers
  
  func presentLoginScreen() {
    DispatchQueue.main.async {
      let controller = LoginController()
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true, completion: nil)
    }
  }
  
  
  func configureUI() {
    view.backgroundColor = .white
    
    configureTableView()
    
    let image = UIImage(systemName: "person.circle.fill")
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
    
    view.addSubview(newMessageButton)
    newMessageButton.setDimensions(height: 56, width: 56)
    newMessageButton.layer.cornerRadius = 56 / 2
    newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
  }
  
  
  func  configureTableView() {
    tableview.backgroundColor = .white
    tableview.rowHeight = 80
    tableview.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableview.tableFooterView = UIView() // if you have only 2 cells, it will give you 2 separetor lines.
    tableview.delegate = self
    tableview.dataSource = self
    
    view.addSubview(tableview)
    tableview.frame = view.frame
    
  }
  
  
  func showChatController(forUser user: User) {
    let controller = ChatController(user: user)
    navigationController?.pushViewController(controller, animated: true)
  }
}


// MARK: - UITableViewDataSource

extension ConversationsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conversations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
    cell.conversation = conversations[indexPath.row]
    return cell
  }
}


// MARK: - UITableViewDelegate

extension ConversationsController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = conversations[indexPath.row].user
    showChatController(forUser: user)
    
//    print(indexPath.row)
  }
}


//  MARK: - NewMessageControllerDelegate

extension ConversationsController: NewMessageControllerDelegate {
  func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
    controller.dismiss(animated: true, completion: nil)
    showChatController(forUser: user)
    
//    print("DEBUG: User in conversation controller is \(user.username)")
  }
}



