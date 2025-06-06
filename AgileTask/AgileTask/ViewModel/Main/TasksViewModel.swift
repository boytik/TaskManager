//
//  TasksView.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import Foundation
import FirebaseAuth

@MainActor
final class TasksViewModel: ObservableObject {
    // MARK: - Properties
    private let taskService = TaskService()
    private let collection: CollectionName = .tasks
    
    @Published var tasks: [TaskModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var makeNewTask = false
    @Published var tasksCategory: ModeOfTask = .all
    @Published var taskForChange: TaskModel?
    @Published var changeIsOn = false
    
    enum ModeOfTask: String, CaseIterable {
        case all = "Входящие"
        case forADay = "Сегодня"
    }
    
    // MARK: - Initialization
    init() {
        loadInitialData()
    }
    
    private func loadInitialData() {
        Task {
            await filterTasksByCategory()
        }
    }
    
    // MARK: - Business Logic
    func filterTasksByCategory() async {
        isLoading = true
        errorMessage = nil
        do {
            isLoading = true
            errorMessage = nil
            tasks.removeAll()
            switch tasksCategory {
            case .forADay:
                let fetchedTasks = try await taskService.fetchTasks(collection: collection)
                tasks = fetchedTasks.filter { $0.today == true }
                
            case .all:
                let fetchedTasks = try await taskService.fetchTasks(collection: collection)
                tasks = fetchedTasks.filter{ $0.today == false || $0.today == nil}
            }
        } catch {
            errorMessage = "Ошибка загрузки задач: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func emergencyTryOn(id: String) async {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Задача не найдена"
            return
        }
        
        do {
            var updatedTask = tasks[index]
            updatedTask.emergency.toggle()
            tasks[index].emergency.toggle()
            
            try await taskService.updateTask(task: updatedTask, collection: collection)

            tasks[index] = updatedTask
        } catch {
            tasks[index].emergency.toggle()
            errorMessage = "Ошибка обновления задачи"
        }
    }
    func toDayTryOn(id: String) async {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Задача не найдена"
            return
        }
        
        do {
            var updatedTask = tasks[index]
            tasks.remove(at: index)
            if updatedTask.today == false || updatedTask.today == nil {
                updatedTask.today = true
                print("Сделали сегодняшней")
            } else {
                updatedTask.today = false
                print("Сбросили сегодняшней")
            }
            tasks.append(updatedTask)
            try await taskService.updateTask(task: updatedTask, collection: collection)
        } catch {
            tasks[index].emergency.toggle()
            errorMessage = "Ошибка обновления задачи"
        }
    }
    
    func deleteTask(id: String) async {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            errorMessage = "Задача не найдена"
            return
        }
        
        do {
            try await taskService.deleteTask(taskId: id, collection: collection)
            tasks.remove(at: index)
        } catch {
            errorMessage = "Ошибка удаления"
        }
    }
    
    func updateTask(task: TaskModel) async {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            errorMessage = "Задача не найдена"
            return
        }
        
        do {
            tasks[index] = task
            try await taskService.updateTask(task: task, collection: collection)
        } catch {
            errorMessage = "Ошибка обновления"
            await filterTasksByCategory()
        }
    }
    
//    func fetchTasks() async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            let fetchedTasks = try await taskService.fetchTasks(collection: collection)
//            tasks = fetchedTasks
//        } catch {
//            errorMessage = "Ошибка загрузки задач: \(error.localizedDescription)"
//        }
//        
//        isLoading = false
//    }
    
    // MARK: - Private Helpers
    private func getUserId() throws -> String {
        guard let userId = UserDefaults.standard.string(forKey: KeysForUserDefaults.userId.rawValue) else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])
        }
        return userId
    }
}
