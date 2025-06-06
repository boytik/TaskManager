//
//  MakeTaskView.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import SwiftUI


struct MakeTaskView: View {
    @Binding var isPresented: Bool
    @State private var flagAnimationIsTrue = false
    @State var viewModel = MakeTaskViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Text("Создать задачу")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    Button(action: {
                        flagAnimationIsTrue.toggle()
                        viewModel.emergency.toggle()
                    }) {
                        Image(systemName: "flag.fill")
                            .foregroundColor(viewModel.emergency ? .red : .gray)
                            .phaseAnimator([FlagIanimation.standart,
                                            FlagIanimation.up,
                                            FlagIanimation.left,
                                            FlagIanimation.right,
                                            FlagIanimation.left,
                                            FlagIanimation.right],
                                           trigger: flagAnimationIsTrue) { flag, phase in
                                flag
                                    .scaleEffect(phase.scale)
                                    .rotationEffect(.degrees(phase.rotation), anchor: .bottom)
                                    .offset(y: phase.yOffset)
                            } animation: { phase in
                                switch phase {
                                case .standart, .up: .spring(bounce: 0.5)
                                case .left, .right: .easeIn(duration: 0.15)
                                }
                            }
                    }
                }
                
                Spacer()
                Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Название")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $viewModel.titel)
                            .frame(minHeight: 40, maxHeight: 100)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                            .scrollContentBackground(.hidden)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Описание")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $viewModel.discription)
                        .frame(minHeight: 100, maxHeight: 200)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                        .scrollContentBackground(.hidden)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // Date Picker
                VStack(spacing: 12) {
                    Divider()
                    
                    HStack {
                        Text("Дата выполнения")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        Toggle("", isOn: $viewModel.showDatePicker)
                            .labelsHidden()
                    }
                    
                    if viewModel.showDatePicker {
                        DatePicker("", selection: $viewModel.deadLine, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .animation(.easeInOut, value: viewModel.showDatePicker)
            }
            .padding(.bottom, 24)
            
            //MARK: Buttons
            HStack(spacing: 16) {
                Button("Отмена") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray5))
                .foregroundColor(.red)
                .cornerRadius(10)
                
                Button(action: {
                    Task { await viewModel.makeTask() }
                }) {
                    Text("Добавить")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
        .onChange(of: viewModel.shouldDismiss) {
            isPresented = false
        }
    }
}
#Preview {
    @Previewable @State var isPresented: Bool = true
    MakeTaskView(isPresented: $isPresented)
}
