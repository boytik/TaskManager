//
//  MakeTaskViewModel.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import Foundation
@Observable
class MakeTaskViewModel {
    private let taskService = TaskService()
    var titel: String = ""
    var discription: String = ""
    var deadLine: Date = Date()
    var showDatePicker: Bool = false
    var shouldDismiss = false
    let curentDate: Date = Date()
    let category: String = CollectionName.tasks.rawValue
    var emergency: Bool = false
    
    func makeTask() async {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            print("беда тут")
            return
        }
        print(userId)
        let makeDate: String? = showDatePicker ? deadLine.dateToString() : nil
        
        let task: TaskModel = .init(userId: userId, title: self.titel, description: self.discription, deadline: makeDate, project: nil, dateWhenTaskDoneIsSet: curentDate.dateToString(), emergency: self.emergency, today: nil, dateWhenTaskDone: nil, category: category, timeForTask: nil)
        Task {
            do {
                try await taskService.addTask(task: task, collection: CollectionName.tasks)
                await MainActor.run {
                    shouldDismiss = true
                }
            } catch {
                print("ошибка при добавлении задачи")
            }
        }
        
    }
}
