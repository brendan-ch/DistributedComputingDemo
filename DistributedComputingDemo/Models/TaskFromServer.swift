//
//  TaskFromServer.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation

struct TaskFromServer: Identifiable {
    let id: Int
    
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

