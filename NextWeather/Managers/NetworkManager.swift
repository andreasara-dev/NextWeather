//
//  NetworkManager.swift
//  NextWeather
//
//  Created by andreasara-dev on 11/09/23.
//

import Foundation
import Network

final class NetworkManager: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
            Task {
                await MainActor.run() {
                    self.objectWillChange.send()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
