//
//  LoginController.swift
//  FireChat
//
//  Created by Elizeu RS on 23/09/21.
//

import UIKit

class LoginController: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = LoginViewModel()
  
  private let iconImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "bubble.right")
    iv.tintColor = .white
    return iv
  }()
  
  private lazy var emailContainerView: UIView = {
    return InputContainerView(image: UIImage(systemName: "envelope"),
                              textField: emailTextField)
  }()
  
  private lazy var passwordContainerView: UIView = {
    return InputContainerView(image: UIImage(systemName: "lock"),
                              textField: passwordTextField)
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log In", for: .normal)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.backgroundColor = .magenta
    button.alpha = 0.5
//    button.layer.borderWidth = 1.0
//    button.layer.borderColor = UIColor.white.cgColor
    button.setTitleColor(.white, for: .normal)
    button.setHeight(height: 50)
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private let emailTextField =   CustomTextField(placeholder: "Email")
  
  private let passwordTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "Password")
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let dontHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                    attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                 .foregroundColor: UIColor.white])
    attributedTitle.append(NSAttributedString(string: "Sign Up",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                           .foregroundColor: UIColor.white]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    
    return  button
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Selectors
  
  @objc func handleLogin() {
    print("DEBUG: Handle login here..")
  }
  
  @objc func handleShowSignUp() {
    let controller = RegistrationController()
    navigationController?.pushViewController(controller, animated: true)
//    print("Show sign up page..")
  }
  
  @objc func textDidChange(sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    } else {
      viewModel.password = sender.text
    }
    
    checkFormStatus()
//    print("Debug: Sender text is \(sender.text)")
  }
  
  
  // MARK: - Helpers
  
  func checkFormStatus() {
    if viewModel.formIsValid {
      loginButton.isEnabled = true
      loginButton.alpha = 1
    } else {
      loginButton.isEnabled = false
      loginButton.alpha = 0.4
    }
  }
  
  func configureUI() {
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black
    
    configureGradientLayer()
    
    view.addSubview(iconImage)
    
    iconImage.centerX(inView: view)
    iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    iconImage.setDimensions(height: 120, width: 120)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                              passwordContainerView,
                                              loginButton])
    stack.axis = .vertical
    stack.spacing = 16
    
    view.addSubview(stack)
    stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    
    emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    
//    iconImage.translatesAutoresizingMaskIntoConstraints = false
//    iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    iconImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    iconImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
//    iconImage.widthAnchor.constraint(equalToConstant: 120).isActive = true

  }
}
