//
//  Service.swift
//  FireChat
//
//  Created by Elizeu RS on 29/09/21.
//

import Firebase

struct Service {
  
  static func fetchUsers() {
    Firestore.firestore().collection("users").getDocuments { snapshot, error in
      snapshot?.documents.forEach({ document in
        print(document.data())
      })
    }
  }
}
