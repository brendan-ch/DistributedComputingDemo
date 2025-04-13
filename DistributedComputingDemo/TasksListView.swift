//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct TasksListView: View {
    var body: some View {
        List {
            Section {
                Button("Task 1") {}
                Button("Task 2") {}
                Button("Task 3") {}
            } footer: {
                Text("To perform a task on another device, select a task above.")
            }
        }
        .navigationTitle("Tasks")
    }
}

#Preview {
    TasksListView()
}
