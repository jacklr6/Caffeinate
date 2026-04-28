//
//  LoginLaunch.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/28/26.
//

import ServiceManagement
internal import Combine

class LaunchAtLoginManager: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            toggle(isEnabled)
        }
    }
    
    init() {
        self.isEnabled = SMAppService.mainApp.status == .enabled
    }
    
    private func toggle(_ enable: Bool) {
        do {
            if enable {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to \(enable ? "enable" : "disable") launch at login. \(error)")
        }
    }
}
