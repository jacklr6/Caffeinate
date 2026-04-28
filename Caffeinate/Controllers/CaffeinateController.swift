//
//  CaffeinateController.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI
internal import Combine

@MainActor
final class CaffeinateController: ObservableObject {
    @Published private(set) var isCaffeinated = false

    private var process: Process?

    func toggleCaffeination() {
        isCaffeinated ? stopCaffeination() : startCaffeination()
    }

    func startCaffeination() {
        guard process == nil else { return }

        let caffeinateProcess = Process()
        caffeinateProcess.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        caffeinateProcess.arguments = ["-dimsu"]

        do {
            try caffeinateProcess.run()
            process = caffeinateProcess
            isCaffeinated = true
        } catch {
            process = nil
            isCaffeinated = false
        }
    }

    func stopCaffeination() {
        process?.terminate()
        process = nil
        isCaffeinated = false
    }
}
