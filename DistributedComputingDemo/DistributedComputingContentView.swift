//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct DistributedComputingContentView: View {
    @StateObject var tasksModel = DistributedComputingTasksModel()
    
    var body: some View {
        List {
            Section(
                header: Text("Toggle computing"),
                footer: Text("Allow tasks to run on this device.")
            ) {
                Toggle(isOn: $tasksModel.distributedComputingEnabled) {
                    Text("Computing enabled")
                }
            }
            
            Section("Past runs") {
                if tasksModel.taskHistory.isEmpty {
                    Text("Past task runs will go here.")
                } else {
                    ForEach(tasksModel.taskHistory) { task in
                        Text(task.name)
                    }
                }
            }
            
            Section("Stats") {
                Text("Stats will go here.")
            }
            
        }
        .navigationTitle("Home")
        
        if let taskToExecuteNext = tasksModel.taskToExecuteNext {
            if taskToExecuteNext.status == .executing {
                // Display the web view to execute the task
                JavaScriptExecutableWebView(javascriptString: taskToExecuteNext.javascriptCode, completionHandler: webViewCallback)
                    .frame(height: 0)
            }
        }
        
    }
    
    func webViewCallback(_ result: Any?, _ error: Any?) {
        if let taskToExecuteNext = tasksModel.taskToExecuteNext {
            if taskToExecuteNext.hasCompleted {
                return
            }
            
            if let error = error {
                tasksModel.taskToExecuteNext?.status = .failed
                tasksModel.taskToExecuteNext?.error = error
            } else if let result = result {
                tasksModel.taskToExecuteNext?.status = .succeeded
                tasksModel.taskToExecuteNext?.result = result
            }
        }
    }
}

#Preview {
    DistributedComputingContentView()
}
