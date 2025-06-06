//
//  TaskSell.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import SwiftUI

struct TaskCell: View {
    @State private var settingsAnimationIsTrue = false
    @State private var flagAnimationIsTrue = false
    var task: TaskModel
    var onPriorityTap: () -> Void
    var settingsTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Main content
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                // Description (if exists)
                if let description = task.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                
                // Deadline (if exists)
                if let deadline = task.deadline, let dateString = deadline.makeLocalDate() {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text(dateString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Action buttons
            HStack(spacing: 0) {
                // Settings button
                Button(action: {
                    settingsAnimationIsTrue.toggle()
                    settingsTap()
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                        .phaseAnimator(SettingsAnimation.allCases, trigger: settingsAnimationIsTrue) { gearshape, phase in
                            gearshape
                                .scaleEffect(phase.scale)
                                .rotationEffect(.degrees(phase.rotation))
                        } animation: { phase in
                            switch phase {
                            case .standart, .left, .down, .right:
                                .easeInOut(duration: 0.3)
                            }
                        }
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                
                // Priority flag
                Button(action: {
                    flagAnimationIsTrue.toggle()
                    onPriorityTap()
                }) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 18))
                        .foregroundColor(task.emergency ? .red : .gray)
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
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
            }
            .foregroundColor(.gray)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.emergency ? Color.red.opacity(0.1) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(task.emergency ? Color.red.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        TaskCell(
            task: TaskModel(
                userId: "",
                title: "Важная задача с длинным названием, которое должно переноситься",
                description: "Описание задачи, которое может быть достаточно длинным и занимать несколько строк",
                deadline: "2023-12-31",
                project: "",
                dateWhenTaskDoneIsSet: Date().dateToString(),
                emergency: true,
                today: false,
                dateWhenTaskDone: "",
                category: "",
                timeForTask: nil
            ),
            onPriorityTap: {},
            settingsTap: {}
        )
        
        TaskCell(
            task: TaskModel(
                userId: "",
                title: "Обычная задача",
                description: "Короткое описание",
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
            settingsTap: {}
        )
    }
    .padding(.vertical)
    .background(Color(.systemBackground))
}
enum FlagIanimation: CaseIterable {
    case standart, up, left, right
    
    var yOffset: CGFloat {
        switch self {
        case .standart: return 0
        case .up, .left, .right: return -15
        }
    }
    var scale: CGFloat {
        switch self {
        case .standart: return 1
        case .up, .left, .right: return 1.4
        }
    }
    var rotation: Double {
        switch self {
        case .standart: return 0
        case .up: return 0
        case .left: return -30
        case .right: return 30
        }
    }
}

enum SettingsAnimation: CaseIterable {
    case standart, left, down, right
    
    var scale: CGFloat {
        switch self {
        case .standart: return 1
        case .left, .down, .right : return 1.5
        }
    }
    var rotation: Double {
        switch self {
        case .standart: return 0
        case .left: return -30
        case .down: return 90
        case .right: return 30
        }
    }
}
