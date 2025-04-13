//
//  TaskView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.13.
//

import SwiftUI

struct TaskView: View {
    var task: TaskFromServer
    
    var body: some View {
        List {
            Section("Code") {
                Text(task.javascriptCode)
                    .monospaced()
            }
            
            Section("Result") {
                Text("\(String(describing: task.result))")
                    .monospaced()
            }
            
            Section("Errors") {
                Text("\((task.error != nil) ? String(describing: task.error) : "N/A")")
                    .monospaced()
            }
        }
        .navigationTitle("Task \(task.id)")
    }
}


#Preview {
    let javascriptCode = """
function hello() {
    return 5 + 1;
}

hello();
"""
    
    var task = TaskFromServer(
        id: 1,
        javascriptCode: javascriptCode
    )
    task.result = "6"
    
    return TaskView(task: task)
}
