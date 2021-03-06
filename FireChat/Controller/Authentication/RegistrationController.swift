//
//  RegistrationController.swift
//  FireChat
//
//  Created by Elizeu RS on 23/09/21.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
  
  
  // MARK: - Properties
  
  private var viewModel = RegistrationViewModel()
  private var profileImage: UIImage?
  
  private let plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
    button.imageView?.contentMode = .scaleAspectFill
    button.imageView?.clipsToBounds = true
    button.clipsToBounds = true
    return button
  }()
  
  private lazy var emailContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: emailTextField)
  }()
  
  private lazy var passwordContainerView: InputContainerView = {
    return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: passwordTextField)
  }()
  
  private lazy var fullnameContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: fullnameTextField)
  }()
  
  private lazy var usernameContainerView: UIView = {
    return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: usernameTextField)
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
    button.backgroundColor = .systemPink
    button.alpha = 0.5
    button.setTitleColor(.white, for: .normal)
//    button.layer.borderWidth = 1.0
//    button.layer.borderColor = UIColor.white.cgColor
    button.setHeight(height: 50)
    button.isEnabled = false
    button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
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
    configureNotificationObservers()
  }
  
  
  // MARK: - Selectors
  
  @objc func handleRegistration() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    guard let fullname = fullnameTextField.text else { return }
    guard let username = usernameTextField.text?.lowercased() else { return }
    guard let profileImage = profileImage else { return }

    let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
    
    showLoader(true, withText: "Signing You Up")
    
    AuthService.shared.createUser(credentials: credentials) { error in
      if let error = error {
        print("DEBUG: \(error.localizedDescription)")
        self.showLoader(false)
        return
      }
      
      self.showLoader(false)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  
  @objc func textDidChange(sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    } else if sender == passwordTextField {
      viewModel.password = sender.text
    } else if sender == fullnameTextField {
      viewModel.fullname = sender.text
    } else {
      viewModel.username = sender.text
    }
    
    checkFormStatus()
  }
  
  
  @objc func handleSelectPhoto()  {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }
  
  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func keyboardWillShow() {
    if view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  @objc func keyboardWillHide() {
    if view.frame.origin.y == 0 {
      view.frame.origin.y = -50
    }
  }
  
  
  // MARK: Helpers
  
  func configureUI() {
    configureGradientLayer()
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.centerX(inView: view)
    plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    plusPhotoButton.setDimensions(height: 200, width: 200)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                               passwordContainerView,
                                               fullnameContainerView,
                                               usernameContainerView,
                                               signUpButton])
    stack.axis = .vertical
    stack.spacing = 16
    
    view.addSubview(stack)
    stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.centerX(inView: view)
    alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
  }
  
  func configureNotificationObservers() {
    emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidHideNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
}


// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.originalImage] as? UIImage
    profileImage = image
    plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    plusPhotoButton.layer.borderColor = UIColor.white.cgColor
    plusPhotoButton.layer.borderWidth = 3.0
    plusPhotoButton.layer.cornerRadius = 200 / 2
    
    dismiss(animated: true, completion: nil)
  }
}


extension RegistrationController: AuthenticationControllerProtocol {
  func checkFormStatus() {
    if viewModel.formIsValid {
      signUpButton.isEnabled = true
      signUpButton.alpha = 1
    } else {
      signUpButton.isEnabled = false
      signUpButton.alpha = 0.5
    }
  }
}
