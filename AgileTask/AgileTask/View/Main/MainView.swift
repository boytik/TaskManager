//
//  TabView.swift
//  AgileTask
//
//  Created by Евгений on 29.05.2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedView: ViewCases = .Tasks
    var body: some View {
        TabView(selection: $selectedView){
            TasksView( selectedView: $selectedView)
                .tabItem{
                    Label("Задачи", systemImage: "list.bullet")
                }
                .tag(ViewCases.Tasks)
            HabbitsView( selectedView: $selectedView)
                .tabItem{
                    Label("Привычки", systemImage: "power.circle.fill")
                }
                .tag(ViewCases.Habbits)
            WorkView(selectedView: $selectedView)
                .tabItem{
                    Label("Работа", systemImage: "square.and.arrow.up")
                }
                .tag(ViewCases.Work)
            StatistickView( selectedView: $selectedView)
                .tabItem{
                    Label("Статистика", systemImage: "chart.bar")
                }
                .tag(ViewCases.Statistick)
            ProfileView( selectedView: $selectedView)
                .tabItem{
                    Label("Профиль", systemImage: "person.circle")
                }
                .tag(ViewCases.Profile)
            
        }
    }
}

enum ViewCases: Hashable {
    case Tasks
    case Habbits
    case Work
    case Statistick
    case Profile
    
}
