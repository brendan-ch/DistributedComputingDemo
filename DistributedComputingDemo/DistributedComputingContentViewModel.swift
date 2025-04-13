//
//  DistributedComputingContentViewModel.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation
import Combine

enum TaskStatus {
    case executing
    case failed
    case succeeded
}

struct TaskFromServer: Identifiable {
    var id = UUID()
    let name: String
    
    let javascriptCode: String
    var result: Any? = nil
    var error: Any? = nil
    
    var status: TaskStatus = .executing {
        didSet {
            if hasCompleted {
                completedAt = Date()
            }
        }
    }
    var completedAt: Date? = nil
    var hasCompleted: Bool {
        status == .failed || status == .succeeded
    }
    var isReadyToPublishToServer: Bool {
        hasCompleted
        && (result != nil || error != nil)
    }
}

class DistributedComputingContentViewModel: ObservableObject {
    @Published var distributedComputingEnabled = false
    
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
        
        $taskToExecuteNext
            .sink { [weak self] taskToExecuteNext in
                guard let taskToExecuteNext = taskToExecuteNext else { return }
                
                if taskToExecuteNext.isReadyToPublishToServer {
                    // Publish to the server
                    self?.publishTaskCompletionToServer()
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
        taskToExecuteNext = nil
    }
    
    func refreshDataFromServer() {
        // TODO: Integrate code from the actual server
        
        if let taskToExecuteNext = taskToExecuteNext {
            if !taskToExecuteNext.hasCompleted {
                // Task is currently being executed, stop server refresh
                print("Task is currently waiting or executing, stopping server refresh")
                return
            }
        }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.taskToExecuteNext = newTask
        }
    }
    
    func publishTaskCompletionToServer() {
        print("Simulating task completion publish")
        
        // Leave the task in the view model for reference
//        taskToExecuteNext = nil
    }
}
