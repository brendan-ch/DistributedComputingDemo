//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct DistributedComputingContentView: View {
    @StateObject var viewModel = DistributedComputingContentViewModel()
    
    var body: some View {
        List {
            Section(
                header: Text("Toggle computing"),
                footer: Text("Allow tasks to run on this device.")
            ) {
                Toggle(isOn: $viewModel.distributedComputingEnabled) {
                    Text("Computing enabled")
                }
            }
            
            Section("Past runs") {
                if viewModel.taskHistory.isEmpty {
                    Text("Past task runs will go here.")
                } else {
                    ForEach(viewModel.taskHistory) { task in
                        Text(task.name)
                    }
                }
            }
            
            Section("Stats") {
                Text("Stats will go here.")
            }
            
        }
        .navigationTitle("Home")
        
        JavaScriptExecutableWebView(javascriptString: "console.log('Hello')") { result, error in
        }
            .frame(height: 0)
    }
}

#Preview {
    DistributedComputingContentView()
}
