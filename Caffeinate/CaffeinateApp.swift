//
//  CaffeinateApp.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI
import AppKit

@main
struct CaffeinateApp: App {
    @StateObject private var controller = CaffeinateController()
    
    var body: some Scene {
        MenuBarExtra("Caffeinate", systemImage: controller.isCaffeinated ? "cup.and.saucer.fill" : "moon.stars.fill") {
            ContentView(controller: controller)
        }
        .menuBarExtraStyle(.window)
    }
}
