//
//  RegistrationController.swift
//  FireChat
//
//  Created by Elizeu RS on 23/09/21.
//

import UIKit

class RegistrationController: UIViewController {
  
  
  // MARK: - Properties
  
  private let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
    return button
  }()
  
  private lazy var emailContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: emailTextField)
  }()
  
  private lazy var fullnameContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: fullnameTextField)
  }()
  
  private lazy var usernameContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: usernameTextField)
  }()
  
  private lazy var passwordContainerView: InputContainerView = {
    return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: passwordTextField)
  }()
  
  private let emailTextField = CustomTextField(placeholder: "Email")
  private let fullnameTextField = CustomTextField(placeholder: "Full Name")
  private let usernameTextField = CustomTextField(placeholder: "Username")

  private let passwordTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "Password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.backgroundColor = .magenta
    button.setTitleColor(.white, for: .normal)
//    button.layer.borderWidth = 1.0
//    button.layer.borderColor = UIColor.white.cgColor
    button.setHeight(height: 50)
    return button
  }()
  
  private let alreadyHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                                                      .foregroundColor: UIColor.white])
    attributedTitle.append(NSAttributedString(string: "Login In", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                                               .foregroundColor: UIColor.white
                                                                               
    ]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
                                                                                                      
    return button
  }()
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  
  // MARK: - Selectore
  @objc func handleSelectPhoto()  {
    print("Select photo here...")
  }
  
  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  
  // MARK: Helpers
  
  func configureUI() {
    configureGradientLayer()
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.centerX(inView: view)
    plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    plusPhotoButton.setDimensions(height: 200, width: 200)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                               fullnameContainerView,
                                               usernameContainerView,
                                               passwordContainerView,
                                               signUpButton])
    stack.axis = .vertical
    stack.spacing = 16
    
    view.addSubview(stack)
    stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.centerX(inView: view)
    alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
  }
}
