//
//  DistributedComputingContentViewModel.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation
import Combine

enum TaskStatus {
    case waiting
    case executing
    case failed
    case succeeded
}

struct TaskFromServer: Identifiable {
    var id = UUID()
    let name: String
    
    let javascriptCode: String
    let result: Any? = nil
    let error: Any? = nil
    
    let status: TaskStatus = .waiting
}

class DistributedComputingContentViewModel: ObservableObject {
    @Published var distributedComputingEnabled = false
    
    @Published var taskHistory: [TaskFromServer] = []
    @Published var taskToExecuteNext: TaskFromServer?
    
    private var dataRefreshLoopTask: Task<Void, Error>?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $distributedComputingEnabled
            .sink { [weak self] isEnabled in
                if isEnabled {
                    self?.startRefreshingData()
                } else {
                    self?.stopRefreshingData()
                }
            }
            .store(in: &cancellables)
    }

    func startRefreshingData(sleepDuration: Duration = .seconds(5)) {
        dataRefreshLoopTask = Task {
            while !Task.isCancelled {
                refreshDataFromServer()
                try? await Task.sleep(for: sleepDuration)
            }
        }
    }
    
    func stopRefreshingData() {
        dataRefreshLoopTask?.cancel()
        dataRefreshLoopTask = nil
    }
    
    func refreshDataFromServer() {
        // TODO: Integrate code from the actual server
        
        print("Simulating new task from server")
        
        // I think this is valid JS?
        let javascriptCode = """
function addTwoNumbers() {
    return 2 + 3;
}

addTwoNumbers();
"""
        
        let newTask = TaskFromServer(
            name: "Add two numbers",
            javascriptCode: javascriptCode
        );
        
        taskToExecuteNext = newTask
    }
}
