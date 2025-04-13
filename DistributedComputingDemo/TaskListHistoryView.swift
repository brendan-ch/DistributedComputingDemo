//
//  TaskListHistoryView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct TaskListHistoryView: View {
    @EnvironmentObject var tasksModel: GlobalTasksModel
    
    // To be loaded from the server
    var body: some View {
        List {
            ForEach(tasksModel.pastTasks) { task in
                NavigationLink {
                    Text("Past task")
                } label: {
                    Text("Task \(task.id)")
                }
            }
        }
    }
}

#Preview {
    let globalTasksModel = GlobalTasksModel()
    globalTasksModel.pastTasks = [
        .init(id: 1, javascriptCode: ""),
        .init(id: 2, javascriptCode: "")
    ]
    
    return TaskListHistoryView()
        .environmentObject(globalTasksModel)
}
