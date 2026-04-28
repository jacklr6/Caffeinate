//
//  ContentView.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @ObservedObject var controller: CaffeinateController
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: controller.isCaffeinated ? "cup.and.saucer.fill" : "moon.stars.fill")
                    .font(.system(size: 30))
                    .frame(width: 40)
                    .contentTransition(.symbolEffect)
                
                VStack {
                    Text(controller.isCaffeinated ? "Mac Stays Awake" : "Sleep Allowed")
                        .font(.title2)
                        .bold()
                    Text(controller.isCaffeinated ? "Your Mac is \(Text("ENERGIZED!").foregroundStyle(.green).fontWeight(.heavy))" : "Your Mac can sleep now.")
                }
                .contentTransition(.numericText())
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            }
            
            VStack {
                Button {
                    withAnimation { controller.toggleCaffeination() }
                } label: {
                    HStack {
                        Image(systemName: controller.isCaffeinated ? "pause.fill" : "play.fill")
                        Text(controller.isCaffeinated ? "Stop" : "Start")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .contentTransition(.symbolEffect)
                }
                .buttonStyle(.glassProminent)
                
                HStack {
                    SettingsLink {
                        Text("Settings")
                            .frame(maxWidth: .infinity)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        NSApp.activate(ignoringOtherApps: true)
                    })
                    
                    Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Text("Quit")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(12)
        .frame(width: 230)
    }
}

#Preview {
    ContentView(controller: CaffeinateController())
}
