//
//  DistributedComputingContentViewModel.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation

struct TaskFromServer: Identifiable {
    var id = UUID()
    let name: String
}

class DistributedComputingContentViewModel: ObservableObject {
    @Published var distributedComputingEnabled = false
    
    @Published var taskHistory: [TaskFromServer] = []
    @Published var currentlyExecutingTask: TaskFromServer?
    
    private var dataRefreshLoopTask: Task<Void, Error>?

    func startRefreshingData(sleepDuration: Duration = .seconds(5)) {
        dataRefreshLoopTask = Task {
            while !Task.isCancelled {
                print("Fetch data from server")
                try? await Task.sleep(for: sleepDuration)
            }
        }
    }
    
    func stopRefreshingData() {
        
    }
}
