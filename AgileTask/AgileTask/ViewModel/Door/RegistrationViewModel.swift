//
//  RegistrationViewModel.swift
//  AgileTask
//
//  Created by Евгений on 28.05.2025.
//

import Foundation
import FirebaseAuth
@Observable
class RegistrationViewModel {
    var email: String = ""
    var password: String = ""
    var closeView = false {
        didSet {
        }
    }
    var showAlert: Bool = false
    var message: String = ""
    
    func registerUser() {
        guard self.password.count > 6 else {
            showAlert = true
            message = "Пароль должен быть не менее 6 символов"
            return
        }
        
        Auth.auth().createUser(withEmail: self.email.lowercased(), password: self.password) { result, error in
            if let error = error {
                self.showAlert = true
                self.message = "Не удалось создать пользователя"
                print(error.localizedDescription)
            }else {
                self.showAlert = true
                self.message = "Регистрация успешна"
                self.closeView = true
            }
        }
    }
    
    func resetPassword() {
        self.password = ""
    }
}
