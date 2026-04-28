//
//  SettingsView.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("General", systemImage: "gear", value: 0) {
                GeneralSettingsView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
            
            Tab("About", systemImage: "info.circle", value: 1) {
                AboutView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .frame(width: 375, height: 200)
        .onDisappear {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}

private struct GeneralSettingsView: View {
    @AppStorage("hasPromptedLaunchAtLogin") private var hasPrompted = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @StateObject private var launchManager = LaunchAtLoginManager()
    @State private var showPrompt = false
    
    var body: some View {
        Form {
            Toggle("Launch at Login", isOn: $launchManager.isEnabled)
            Toggle("Dark Mode", isOn: $isDarkMode)
        }
        .formStyle(.grouped)
        .padding()
        .onAppear {
            if !hasPrompted {
                showPrompt = true
                hasPrompted = true
            }
        }
        .alert("Launch at Login", isPresented: $showPrompt) {
            Button("Enable") { launchManager.isEnabled = true }
            Button("Not Now", role: .cancel) { }
        } message: {
            Text("Would you like Caffeinate to launch automatically when you log in?")
        }
    }
}

private struct AboutView: View {
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var appBuild: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
    
    var body: some View {
        VStack {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 65))

            VStack {
                Text("Caffeinate")
                    .font(.system(size: 30, weight: .semibold))
                    .fontWidth(.expanded)
                Text("for \(Image(systemName: "apple.logo")) MacOS | \(Text("\(appVersion) (\(appBuild)) Beta").fontWeight(.bold).foregroundStyle(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)))")
                Text("Built in Gettysburg, PA")
                Text("Jack Rogers | 2026")
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SettingsView()
}
