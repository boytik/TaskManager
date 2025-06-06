//
//  RegistrationView.swift
//  AgileTask
//
//  Created by Евгений on 28.05.2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var viewModel = RegistrationViewModel()
    @Binding var showRegistration: Bool
    var body: some View {
        Text("Регистрация")
        Spacer()
        VStack {
            VStack {
                Text("Email")
                TextField("Email", text: $viewModel.email)
            }
            VStack {
                Text("Пароль")
                SecureField("Пароль", text: $viewModel.password)
            }
            Button("Создать"){
                viewModel.registerUser()
            }
            .alert("", isPresented: $viewModel.showAlert){
                Button("Ok", role: .cancel){
                    if viewModel.showAlert {
                        self.showRegistration.toggle()
                    }
                }
            } message: {
                Text(viewModel.message)
            }
        }
        Spacer()
        Button("Есть аккаунт?"){
            
        }
    }
}
#Preview {
    @Previewable @State var showRegistration: Bool = true
    RegistrationView(showRegistration: $showRegistration)
}
