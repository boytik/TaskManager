//
//  TaskManager.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

final class TaskService {
    private let db = Firestore.firestore()
    
    private func tasksCollection(collection: CollectionName) -> CollectionReference {
        let userId = UserDefaults.standard.string(forKey: KeysForUserDefaults.userId.rawValue)
        guard let userId = userId else { fatalError("User ID cannot be empty") }
        return db.collection("users").document(userId).collection(collection.rawValue)
    }
    
    func addTask(task: TaskModel, collection: CollectionName) async throws {
        try tasksCollection(collection: collection).addDocument(from: task)
    }
    
    func fetchTasks(collection: CollectionName) async throws -> [TaskModel] {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let db = Firestore.firestore()
        let tasksRef = db.collection("users")
            .document(currentUserId)
            .collection(collection.rawValue)
        
        let snapshot = try await tasksRef
            .order(by: "dateWhenTaskDoneIsSet", descending: false)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let task = try document.data(as: TaskModel.self)
                return task
            } catch {
                print("Ошибка парсинга документа \(document.documentID): \(error.localizedDescription)")
                print("Данные документа: \(document.data())")
                return nil
            }
        }
    }
    
    func deleteTask(taskId: String, collection: CollectionName) async throws {
        try await tasksCollection(collection: collection).document(taskId).delete()
    }
    
    func updateTask(task: TaskModel, collection: CollectionName) async throws {
        guard let taskId = task.id else { throw NSError(domain: "Task ID is missing", code: -1) }
        try tasksCollection(collection: collection).document(taskId).setData(from: task)
    }
}
