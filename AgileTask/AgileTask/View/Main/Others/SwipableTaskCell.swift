//
//  SwipableTaskCell.swift
//  AgileTask
//
//  Created by Евгений on 02.06.2025.
//

import SwiftUI
import SwipeActions

struct SwipableTaskCell: View {
    let task: TaskModel
    let onPriorityTap: () -> Void
    let onSettingsTap: () -> Void
    let onDelete: () -> Void
    let moveToToday: () -> Void
    let moveToWork: () -> Void
    let returnToAll: () -> Void
    
    private var todayColor: Color { .orange }
    private var workColor: Color { .blue }
    private var returnColor: Color { .green }
    private var deleteColor: Color { .red }
    
    var body: some View {
        SwipeView {
            TaskCell(task: task,
                    onPriorityTap: onPriorityTap,
                    settingsTap: onSettingsTap)
        } leadingActions: { context in
            if task.today == nil || task.today == false {
                SwipeAction("Сегодня", systemImage: "sun.max.fill", backgroundColor: todayColor) {
                    moveToToday()
                    context.state.wrappedValue = .closed
                }
                .font(.system(size: 12))
                .foregroundColor(.white)
            }
            
            SwipeAction("В работу", systemImage: "briefcase.fill", backgroundColor: workColor) {
                moveToWork()
                context.state.wrappedValue = .closed
            }
            .font(.system(size: 12))
            .foregroundColor(.white)
            
        } trailingActions: { context in
            if task.today == true {
                SwipeAction("Отложить", systemImage: "arrow.uturn.backward", backgroundColor: returnColor) {
                    returnToAll()
                    context.state.wrappedValue = .closed
                }
                .font(.system(size: 12))
                .foregroundColor(.white)
            }
            
            SwipeAction("Удалить", systemImage: "trash.fill", backgroundColor: deleteColor) {
                onDelete()
                context.state.wrappedValue = .closed
            }
            .font(.system(size: 12))
            .foregroundColor(.white)
        }
        .swipeActionWidth(80)
        .swipeActionCornerRadius(12)
        .swipeActionsStyle(.mask)
        .swipeSpacing(4)
        .transition(.slide)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        SwipableTaskCell(
            task: TaskModel(
                userId: "",
                title: "Задача на сегодня",
                description: "Пример задачи с активными свайп-действиями",
                deadline: nil,
                project: "",
                dateWhenTaskDoneIsSet: Date().dateToString(),
                emergency: false,
                today: true,
                dateWhenTaskDone: "",
                category: "",
                timeForTask: nil
            ),
            onPriorityTap: {},
            onSettingsTap: {},
            onDelete: {},
            moveToToday: {},
            moveToWork: {},
            returnToAll: {}
        )
        
        SwipableTaskCell(
            task: TaskModel(
                userId: "",
                title: "Обычная задача",
                description: "Можно перенести в сегодня или в работу",
                deadline: nil,
                project: "",
                dateWhenTaskDoneIsSet: Date().dateToString(),
                emergency: false,
                today: false,
                dateWhenTaskDone: "",
                category: "",
                timeForTask: nil
            ),
            onPriorityTap: {},
            onSettingsTap: {},
            onDelete: {},
            moveToToday: {},
            moveToWork: {},
            returnToAll: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
