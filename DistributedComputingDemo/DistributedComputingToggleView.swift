//
//  TasksListView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI

struct DistributedComputingToggleView: View {
    @State var distributedComputingEnabled = false
    
    var body: some View {
        List {
            Section(
                header: Text("Toggle computing"),
                footer: Text("Allow tasks to run on this device.")
            ) {
                Toggle(isOn: $distributedComputingEnabled) {
                    Text("Computing enabled")
                }
            }
            
            Section("Past runs") {
                Text("Past task runs go here.")
            }
            
            Section("Stats") {
                Text("Stats will go here.")
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    DistributedComputingToggleView()
}
