//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct DistributedComputingContentView: View {
    @StateObject var viewModel = DistributedComputingContentViewModel()
    
    var lastRunText: String {
        if let taskToExecuteNext = viewModel.taskToExecuteNext {
            if taskToExecuteNext.status == .executing {
                return "Executing now..."
            }
            if let completedAt = taskToExecuteNext.completedAt {
                return "Last run: \(completedAt.description)"
            }
        }
        return "Last run: N/A"
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Toggle computing"),
                footer: Text(viewModel.distributedComputingEnabled ? "Monitoring for tasks on the server." : "Turn on to retrieve tasks from the server.")
            ) {
                Toggle(isOn: $viewModel.distributedComputingEnabled) {
                    Text("Computing enabled")
                }
            }
            
            Section(
                header: Text("Past runs"),
                footer: Text(lastRunText)
            ) {
                NavigationLink(destination: TaskListHistoryView()) {
                    Text("View past runs")
                }
            }
            
            Section("Stats") {
                Text("Stats will go here.")
            }
            
        }
        .navigationTitle("Home")
        
        if let taskToExecuteNext = viewModel.taskToExecuteNext {
            if taskToExecuteNext.status == .executing {
                // Display the web view to execute the task
                JavaScriptExecutableWebView(javascriptString: taskToExecuteNext.javascriptCode, completionHandler: webViewCallback)
                    .frame(height: 0)
            }
        }
        
    }
    
    func webViewCallback(_ result: Any?, _ error: Any?) {
        if let taskToExecuteNext = viewModel.taskToExecuteNext {
            if taskToExecuteNext.hasCompleted {
                return
            }
            
            withAnimation {
                if let error = error {
                    viewModel.taskToExecuteNext?.status = .failed
                    viewModel.taskToExecuteNext?.error = error
                } else if let result = result {
                    viewModel.taskToExecuteNext?.status = .succeeded
                    viewModel.taskToExecuteNext?.result = result
                }
            }
        }
    }
}

#Preview {
    DistributedComputingContentView()
}
