//
//  DistributedComputingDemoApp.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

@main
struct DistributedComputingDemoApp: App {
    @State var tabSelection: Int = 0
    @StateObject var tasksModel = GlobalTasksModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DistributedComputingContentView()
            }
            .environmentObject(tasksModel)
        }
    }
}
