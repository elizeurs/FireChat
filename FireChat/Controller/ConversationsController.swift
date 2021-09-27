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
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureNavigationBar()
    configureTableView()
    authenticateUser()
  }
  
  
  // MARK: - Selectors
  
  @objc func showProfile() {
    logout()
//    print(123)
  }
  
  // MARK - API
  
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
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Messages"
    
    let image = UIImage(systemName: "person.circle.fill")
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
  }
  
  
  func  configureTableView() {
    tableview.backgroundColor = .white
    tableview.rowHeight = 80
    tableview.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableview.tableFooterView = UIView() // if you have only 2 cells, it will give you 2 separetor lines.
    tableview.delegate = self
    tableview.dataSource = self
    
    view.addSubview(tableview)
    tableview.frame = view.frame
    
  }
  
  
  func configureNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.backgroundColor = .purple

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance

    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Messages"
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.isTranslucent = true

    navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
  }
}


extension ConversationsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel?.text = "Test Cell"
    return cell
  }
  
  
}


extension ConversationsController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
  }
}



