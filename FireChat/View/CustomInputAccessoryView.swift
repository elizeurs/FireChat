//
//  CustomInputAccessoryView.swift
//  FireChat
//
//  Created by Elizeu RS on 01/10/21.
//

import UIKit

// Using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead
// Replace 'class' with 'AnyObject'
protocol CustomInputAccessoryViewDelegate: AnyObject {
  func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

class CustomInputAccessoryView: UIView {
  
  // MARK: - Properties
  
  weak var delegate : CustomInputAccessoryViewDelegate?
  
  private lazy var messageInputTextView: UITextView = {
    let tv = UITextView()
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.isScrollEnabled = false
    return tv
  }()
  
  private lazy var sendButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Send", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.systemPurple, for: .normal)
    button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
    return button
  }()
  
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.text = "Enter Message"
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .lightGray
    return label
  }()
  
  
  // MARK: Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    autoresizingMask = .flexibleHeight
    
    layer.shadowOpacity = 0.25
    layer.shadowRadius = 10
    layer.shadowOffset = .init(width: 0, height: -8)
    layer.shadowColor = UIColor.lightGray.cgColor
    
    addSubview(sendButton)
    sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8, width: 50, height: 50)
    
    addSubview(messageInputTextView)
    messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
    
    addSubview(placeholderLabel)
    placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
    placeholderLabel.centerY(inView: messageInputTextView)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
  }
  
  override var intrinsicContentSize: CGSize {
    return .zero
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Selectors
  
  @objc func handleTextInputChange() {
    placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
  }
  
  
  @objc func handleSendMessage() {
    guard let message = messageInputTextView.text else { return }
    delegate?.inputView(self, wantsToSend: message)
    
//    print("DEBUG: Handle send message here..")
  }
  
  
  // MARK: - Helpers
  
  func clearMessageText() {
    messageInputTextView.text = nil
    placeholderLabel.isHidden = false
  }
}

