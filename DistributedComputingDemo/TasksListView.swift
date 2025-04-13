//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct TasksListView: View {
    @State var distributedComputingEnabled = false
    
    var body: some View {
        List {
            Section {
                Button("Task 1") {}
                Button("Task 2") {}
                Button("Task 3") {}
            } footer: {
                Text("To perform a task on another device, select a task above.")
            }
            Section {
                Toggle(isOn: $distributedComputingEnabled) {
                    Text("Computing enabled")
                }
            } footer: {
                Text("Allow tasks to run on this device.")
            }
        }
        .navigationTitle("Tasks")
    }
}

#Preview {
    TasksListView()
}
