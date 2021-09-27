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
    
    guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
    
    let filename = NSUUID().uuidString
    let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
    
    ref.putData(imageData, metadata: nil) { (Meta, error) in
      if let error = error {
        print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
        return
      }
      
      ref.downloadURL { (url, error) in
        guard let profileImageUrl = url?.absoluteString else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
          if let error = error {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            return
          }
          
          guard let uid = result?.user.uid else { return }
          
          let data = ["email": email,
                      "fullname": fullname,
                      "profileImageUrl": profileImageUrl,
                      "uid": uid,
                      "username": username] as [String : Any]
          
          Firestore.firestore().collection("users").document(uid).setData(data) { error in
            if let error = error {
              print("DEBUG: Failed to upload user data with error: \(error.localizedDescription)")
              return
            }
            
            self.dismiss(animated: true, completion: nil)
//            print("DEBUG: Did create user..")
          }
        }
      }
    }

    
//    print(email)
//    print(password)
//    print(fullname)
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
  
  func configureNotificationObservers() {
    emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
