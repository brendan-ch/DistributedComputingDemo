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
    let result: Any?
    let error: Any?
    
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
        print("Fetch data from server")
    }
}
