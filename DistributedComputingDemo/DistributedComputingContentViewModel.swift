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

struct TaskFromServerResponse: Decodable {
    let id: Int
    let code: String
    let status: String
    let result: String?
    let device_id: Int?
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
                    self?.publishTaskCompletionToServer(taskToExecuteNext)
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
        if let taskToExecuteNext = taskToExecuteNext {
            if !taskToExecuteNext.hasCompleted {
                // Task is currently being executed, stop server refresh
                print("Task is currently waiting or executing, not refreshing from server")
                return
            }
        }
        
        let baseUrl = URL.apiBaseUrl
        let url = baseUrl.appendingPathComponent("/tasks/next")

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("refreshDataFromServer: Server returned with status code \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else { return }
            print("Data received from server")
            
            if let decodedTask = try? JSONDecoder().decode(TaskFromServerResponse.self, from: data) {
                let convertedTask = TaskFromServer(
                    id: decodedTask.id,
                    javascriptCode: decodedTask.code
                )
                
                DispatchQueue.main.async {
                    self?.taskToExecuteNext = convertedTask
                }
            }
        }.resume()
    }
    
    func publishTaskCompletionToServer(_ task: TaskFromServer) {
        let baseUrl = URL.apiBaseUrl
        let url = baseUrl.appendingPathComponent("/tasks/\(task.id)/complete")

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var result = "\(task.result ?? "")"
        if task.error != nil {
            result = "Error: \(String(describing: task.error))"
        }
        
        let payload: [String: Any] = [
            "status": "COMPLETE",
            "result": result
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("publishTaskCompletionToServer: No valid response")
                return
            }

            if httpResponse.statusCode != 200 {
                print("publishTaskCompletionToServer: Server returned with status code \(httpResponse.statusCode)")
                return
            }

            print("Task completion published successfully")
        }.resume()
    }
}
