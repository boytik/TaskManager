//
//  TaskModel.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//
import Firebase
import FirebaseFirestore

struct TaskModel: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let description: String?
    let deadline: String?
    let project: String?
    let dateWhenTaskDoneIsSet: String
    var emergency: Bool
    var today: Bool?
    let dateWhenTaskDone: String?
    let category: CollectionName.RawValue
    let timeForTask: Int?
}
enum CollectionName: String {
    case tasks = "tasks"
    case statistk = "statistics"
}
