//
//  ContentView.swift
//  AgileTask
//
//  Created by Евгений on 28.05.2025.
//

import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    var body: some View {
        VStack {
            Text("Agile Life")
                .font(.largeTitle)
                .padding(.vertical)
            Spacer()
            VStack(alignment: .center) {
                VStack {
                    Text("Email")
                    TextField("Email", text: $viewModel.email)
                }
                Divider()
                VStack {
                    Text("Password")
                    SecureField("Password", text: $viewModel.password)
                }
                Button("Забыли пароль?"){
                    
                }
            }
            Spacer()
            VStack {
                Button("Войти"){viewModel.loggIn()}
                    .alert("Внимание", isPresented: $viewModel.showAlert){
                        Button("OK"){viewModel.showAlert = false}
                    } message: {
                        Text(viewModel.alertMessage)
                    }
                    .padding(.vertical)
                Button("Зарегистрироваться"){viewModel.registration()}
                    .sheet(isPresented: $viewModel.showRegistration){
                        RegistrationView(showRegistration: $viewModel.showRegistration)
                    }
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    AuthView()
}
