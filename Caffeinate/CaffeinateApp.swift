//
//  CaffeinateApp.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI
import AppKit
import ServiceManagement

@main
struct CaffeinateApp: App {
    @StateObject private var controller = CaffeinateController()
    @AppStorage("hasPromptedLaunchAtLogin") private var hasPrompted = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showPrompt = false

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        Group {
            MenuBarExtra("Caffeinate", systemImage: controller.isCaffeinated ? "cup.and.saucer.fill" : "moon.stars.fill") {
                ContentView(controller: controller)
                    .onAppear {
                        if !hasPrompted {
                            showPrompt = true
                            hasPrompted = true
                        }
                        
                        updateAppearance()
                    }
                    .onChange(of: isDarkMode) {
                        updateAppearance()
                    }
                    .alert("Launch at Login", isPresented: $showPrompt) {
                        Button("Enable") {
                            try? SMAppService.mainApp.register()
                        }
                        Button("Not Now", role: .cancel) { }
                    } message: {
                        Text("Would you like Caffeinate to launch automatically when you log in?")
                    }
            }
            .menuBarExtraStyle(.window)
            
            Settings {
                SettingsView()
                    .onAppear {
                        updateAppearance()
                    }
                    .onChange(of: isDarkMode) {
                        updateAppearance()
                    }
            }
        }
    }
    
    func updateAppearance() {
        NSApp.appearance = isDarkMode ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua)
    }
}
