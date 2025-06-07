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
        VStack {
            VStack {
                Group {
                    Text("Регистрация")
                        .font(.title)
                }
                Spacer()
                Group {
                    Text("Email")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    TextField("email@example.com", text: $viewModel.email)
                        .frame(height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        .autocorrectionDisabled(true)
                    Text("Пароль")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    SecureField("Пароль", text: $viewModel.password)
                        .frame(height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                        .autocorrectionDisabled(true)
                }
                Spacer()
                Group {
                    Button("Создать"){ viewModel.registerUser() }
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                        }
                        .font(.callout)
                        .foregroundStyle(.white)
                        .alert("", isPresented: $viewModel.showAlert){
                            Button("Ok", role: .cancel){
                                if viewModel.showAlert { self.showRegistration.toggle() }
                            }} message: { Text(viewModel.message)}
                        .padding(.vertical)
                    Button("Есть аккаунт?"){}
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}
//#Preview {
//    @Previewable @State var showRegistration: Bool = true
//    RegistrationView(showRegistration: $showRegistration)
//}
