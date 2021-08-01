//
//  NetworkStatus.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation
import Network

class NetworkStatus {
    static let shared = NetworkStatus()
    var monitor: NWPathMonitor?
    var isMonitoring = false
    var netStatusChangeHandler: (() -> Void)?
    private init(){
        startMonitoring()
    }
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    var networkEnabled: Bool = true
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                self.networkEnabled = true
            } else {
                self.networkEnabled = false
                print("Not connection.")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() +  .milliseconds(1000), execute: {
                self.netStatusChangeHandler?()
            })
        }
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else {
            return
        }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
}
