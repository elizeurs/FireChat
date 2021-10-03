//
//  MessageViewModel.swift
//  FireChat
//
//  Created by Elizeu RS on 02/10/21.
//

import UIKit

struct MessageViewModel {
  
  private let message: Message
  
  var messageBackgroundColor: UIColor {
    return message.isFromCurrentUser ? .systemGray5 : .systemPurple
  }
  
  var messageTextColor: UIColor {
    return message.isFromCurrentUser ? .black : .white
  }
  
  var rightAnchorActive: Bool {
    return message.isFromCurrentUser
  }
  
  var leftAnchorActive: Bool {
    return !message.isFromCurrentUser
  }
  
  var shouldHideProfileImage: Bool {
    return message.isFromCurrentUser
  }
  
  init(message: Message) {
    self.message = message
  }
}
