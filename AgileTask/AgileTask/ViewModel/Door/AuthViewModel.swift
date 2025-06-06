//
//  AuthViewModel.swift
//  AgileTask
//
//  Created by Евгений on 28.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthViewModel {
    var email:String = ""
    var password:String = ""
    var showRegistration: Bool = false
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    func loggIn() {
        Auth.auth().signIn(withEmail: self.email.lowercased(), password: self.password){ result, error in
            if error != nil {
                self.showAlert = true
                self.alertMessage = "не удалось авторизоваться"
            }
            if let result = result {
                UserDefaults.standard.set(true, forKey: "Auth")
                let user = result.user.uid
                UserDefaults.standard.set(user, forKey: "UserId")
                print(user)
            }
        }
    }
    
    func registration() {
        self.showRegistration = true
    }
}
