//
//  TasksView.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//
import SwiftUI
import SwipeActions
struct TasksView: View {
    @StateObject var viewModel = TasksViewModel()
    @Binding var selectedView: ViewCases
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    modePicker
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else if viewModel.tasks.isEmpty {
                        emptyTasksView
                    } else {
                        tasksGrid
                    }
                    Spacer()
                }
            }
            .navigationTitle("Задачи")
            .toolbar { toolbarContent }
            .sheet(isPresented: $viewModel.makeNewTask) { makeTaskView }
            .task { await viewModel.filterTasksByCategory() }
            .refreshable { await viewModel.filterTasksByCategory() }
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { message in
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: { message in
                Text(message)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var modePicker: some View {
        Picker("Режим", selection: $viewModel.tasksCategory) {
            ForEach(TasksViewModel.ModeOfTask.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: viewModel.tasksCategory) {
            Task { await viewModel.filterTasksByCategory() }
        }
    }
    
    private var emptyTasksView: some View {
        ContentUnavailableView(
            "Нет задач",
            systemImage: "checklist",
            description: Text("Добавьте новую задачу")
        )
    }
    
    private var tasksGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            ForEach(viewModel.tasks, id: \.id) { task in
                taskCell(for: task)
            }
        }
        .padding(.horizontal)
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { viewModel.makeNewTask = true }) {
                Image(systemName: "plus")
            }
        }
    }
    
    private var makeTaskView: some View {
        MakeTaskView(isPresented: $viewModel.makeNewTask)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
    }
    
    // MARK: - Helper Functions
    
    private func taskCell(for task: TaskModel) -> some View {
        SwipableTaskCell(
            task: task,
            onPriorityTap: { Task { await viewModel.emergencyTryOn(id: task.id ?? "") } },
            onSettingsTap: {
                viewModel.taskForChange = task
                viewModel.changeIsOn.toggle()
            },
            onDelete: { Task { await viewModel.deleteTask(id: task.id ?? "") } },
            moveToToday: { Task { await viewModel.toDayTryOn(id: task.id ?? "") } },
            moveToWork: { self.selectedView = .Work },
            returnToAll: { Task { await viewModel.toDayTryOn(id: task.id ?? "") } }
        )
    }
}
