//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Elizeu RS on 25/09/21.
//

import Foundation

protocol AuthenticationProtocol {
  var formIsValid: Bool { get }
}

struct LoginViewModel {
  var email: String?
  var password: String?
  
  var formIsValid: Bool {
    return email?.isEmpty == false
    && password?.isEmpty == false
  }
}
