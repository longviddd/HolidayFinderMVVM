//
//  HolidayFinderApp.swift
//  HolidayFinder
//
//  Created by long on 2024-02-03.
//

import SwiftUI

@main
struct HolidayFinderApp: App {
    // Create the system monitor instance
    private let systemMonitor = SystemMonitor()
    private let ramMonitor = MemoryUsageMonitor()
    
    init() {
        // Start monitoring CPU usage as soon as the app launches
        systemMonitor.startMonitoring()
        ramMonitor.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.value(forKey: "selectedAirport") as? Data != nil {
                MainTabView()
                    .navigationViewStyle(.stack)
            } else {
                AirportSelectionView()
            }
        }
    }
}

import Foundation

class SystemMonitor {
    private var timer: Timer?
    private var combinedUsages: [Float] = []
    private var maxCPUUsage: Float = 0.0  // Variable to store the maximum CPU usage
    private var startTime: Date?

    func startMonitoring() {
        combinedUsages.removeAll()  // Reset the usage data each time monitoring starts
        maxCPUUsage = 0.0  // Reset the maximum CPU usage
        startTime = Date()  // Record the start time for reference
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchCPUUsage), userInfo: nil, repeats: true)
    }

    func stopMonitoring() {
        timer?.invalidate()
        let totalTime = Date().timeIntervalSince(startTime ?? Date())
        print("Monitoring stopped after \(totalTime) seconds.")
    }

    @objc private func fetchCPUUsage() {
        var cpuInfo = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)

        let result = withUnsafeMutablePointer(to: &cpuInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }

        if result == KERN_SUCCESS {
            let userTicks = cpuInfo.cpu_ticks.0
            let systemTicks = cpuInfo.cpu_ticks.1
            let idleTicks = cpuInfo.cpu_ticks.2
            let totalTicks = userTicks + systemTicks + idleTicks + cpuInfo.cpu_ticks.3

            if totalTicks > 0 {
                let userUsage = Float(userTicks) / Float(totalTicks) * 100
                let systemUsage = Float(systemTicks) / Float(totalTicks) * 100
                let combinedUsage = userUsage + systemUsage

                combinedUsages.append(combinedUsage)
                // Update maximum CPU usage if the current usage is higher
                if combinedUsage > maxCPUUsage {
                    maxCPUUsage = combinedUsage
                }

                let averageUsage = combinedUsages.reduce(0, +) / Float(combinedUsages.count)
                print("Average Combined CPU Usage: \(averageUsage)%")
                print("Maximum Combined CPU Usage: \(maxCPUUsage)%")
            }
        } else {
            print("Error fetching CPU data: \(result)")
        }
    }
}



import Foundation
import MachO

class MemoryUsageMonitor {
    var timer: Timer?
    var memoryUsages: [UInt64] = []
    var maxMemoryUsage: UInt64 = 0

    func startMonitoring() {
        memoryUsages = []
        maxMemoryUsage = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(reportMemoryUsage), userInfo: nil, repeats: true)
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    @objc func reportMemoryUsage() {
        let usedMemory = self.usedMemory()
        memoryUsages.append(usedMemory)
        if usedMemory > maxMemoryUsage {
            maxMemoryUsage = usedMemory
        }
        
        let averageMemoryUsage = memoryUsages.reduce(0, +) / UInt64(memoryUsages.count)
        print("Average Memory Usage: \(averageMemoryUsage) MB")
        print("Maximum Memory Usage: \(maxMemoryUsage) MB")
    }


    func usedMemory() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            return info.resident_size / 1024 / 1024 // Convert from bytes to megabytes
        } else {
            print("Error with task_info(): \(String(describing: strerror(kerr)))")
            return 0
        }
    }
}
