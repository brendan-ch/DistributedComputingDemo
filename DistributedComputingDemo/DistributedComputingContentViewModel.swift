//
//  DistributedComputingContentViewModel.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation

class DistributedComputingContentViewModel: ObservableObject {
    private var dataRefreshLoopTask: Task<Void, Error>?
    @Published var distributedComputingEnabled = false

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
