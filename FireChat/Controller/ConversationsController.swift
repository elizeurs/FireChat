//
//  ConversationsController.swift
//  FireChat
//
//  Created by Elizeu RS on 22/09/21.
//

import UIKit

class ConversationsController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureNavigationBar()
  }
  
  // MARK: - Selectors
  
  @objc func showProfile() {
    print(123)
  }
  
  // MARK: - Helpers
  
  func configure() {
    view.backgroundColor = .white
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Messages"
    
    let image = UIImage(systemName: "person.circle.fill")
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
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
