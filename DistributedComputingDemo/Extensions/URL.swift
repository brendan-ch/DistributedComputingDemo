//
//  URL.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import Foundation

extension URL {
    static var defaultApiBaseUrl: URL {
        return URL(string: "http://localhost:8000")!
    }
}
