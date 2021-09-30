//
//  Service.swift
//  FireChat
//
//  Created by Elizeu RS on 29/09/21.
//

import Firebase

struct Service {
  
  static func fetchUsers(completion: @escaping([User]) -> Void) {
    var users = [User]()
    Firestore.firestore().collection("users").getDocuments { snapshot, error in
      snapshot?.documents.forEach({ document in
        
        let dictionary = document.data()
        let user = User(dictionary: dictionary)
        users.append(user)
        completion(users)
        
//        print("DEBUG: Username is \(user.username)")
//        print("DEBUG: Fullname is \(user.fullname)")
        
//        print(document.data())
      })
    }
  }
}
