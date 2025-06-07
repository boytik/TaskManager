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
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("write@example.com", text: $viewModel.email)
                        .frame(height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        .autocorrectionDisabled(true)
                    HStack {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Забыли пароль?"){}
                            .font(.subheadline)
                    }
                    SecureField("*******", text: $viewModel.password)
                        .frame(height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        .autocorrectionDisabled(true)
                }
            }
            Spacer()
            VStack {
                Button("Войти"){viewModel.loggIn()}
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue)
                    }
                    .font(.callout)
                    .foregroundStyle(.white)
                    .alert("Внимание", isPresented: $viewModel.showAlert){
                        Button("OK"){viewModel.showAlert = false}
                    } message: {
                        Text(viewModel.alertMessage)
                    }
                    .padding(.vertical)
                Button("Зарегистрироваться?"){viewModel.registration()}
                    .font(.callout)
                    .sheet(isPresented: $viewModel.showRegistration){
                        RegistrationView(showRegistration: $viewModel.showRegistration)
                    }
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    AuthView()
//}
