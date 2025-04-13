//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct DistributedComputingContentView: View {
    @EnvironmentObject var tasksModel: GlobalTasksModel
    @Environment(\.colorScheme) var colorScheme
    
    var lastRunText: String {
        if let taskToExecuteNext = tasksModel.taskToExecuteNext {
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
        VStack(spacing: 0) {
            List {
                Section(
                    header: Text("Toggle computing"),
                    footer: Text(tasksModel.distributedComputingEnabled ? "Monitoring for tasks on the server." : "Turn on to retrieve tasks from the server.")
                ) {
                    Toggle(isOn: $tasksModel.distributedComputingEnabled) {
                        Text("Computing enabled")
                    }
                    
                    TextField("Server base URL", text: $tasksModel.baseUrl)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .disabled(tasksModel.distributedComputingEnabled)
                }
                
                Section(
                    header: Text("Past runs"),
                    footer: Text(lastRunText)
                ) {
                    NavigationLink(destination: TaskListHistoryView()) {
                        Text("View past runs")
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("How this works", systemImage: "info.circle")
                            .font(.headline)
                        Text("When computing is enabled, your device will check in with the server periodically to retrieve a JavaScript-based task. If one is found, it executes the code and reports the result back to the server.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
            }
            .navigationTitle("Node Settings")
            
            if let taskToExecuteNext = tasksModel.taskToExecuteNext {
                if taskToExecuteNext.status == .executing {
                    // Display the web view to execute the task
                    JavaScriptExecutableWebView(javascriptString: taskToExecuteNext.javascriptCode, completionHandler: webViewCallback)
                        .frame(height: 0)
                        .background(Color(colorScheme == .light ? UIColor.secondarySystemBackground : UIColor.systemBackground))
                }
            }
        }
    }
    
    func webViewCallback(_ result: Any?, _ error: Any?) {
        if let taskToExecuteNext = tasksModel.taskToExecuteNext {
            if taskToExecuteNext.hasCompleted {
                return
            }
            
            withAnimation {
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
}

#Preview {
    DistributedComputingContentView()
        .environmentObject(GlobalTasksModel())
}
