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
    @State private var isHovering = false
    
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
                .buttonStyle(EnergeticButtonStyle(isHovering: isHovering))
                .onHover { hovering in
                    if !controller.isCaffeinated {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            isHovering = hovering
                        }
                    }
                }
                
                HStack {
                    SettingsLink {
                        Text("Settings")
                            .frame(maxWidth: .infinity)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        NSApp.activate(ignoringOtherApps: true)
                    })
                    
                    Button(action: {
                        controller.stopCaffeination()
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

struct BoltGrid: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let symbol = context.resolveSymbol(id: "bolt")!
                let spacing: CGFloat = 25
                let time = timeline.date.timeIntervalSinceReferenceDate
                let offset = (time * 12).remainder(dividingBy: spacing)
                
                context.opacity = 0.15
                
                for x in stride(from: -spacing, through: size.width + spacing, by: spacing) {
                    for y in stride(from: -spacing, through: size.height + spacing, by: spacing) {
                        context.draw(symbol, at: CGPoint(x: x - offset, y: y - offset))
                    }
                }
            } symbols: {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 14))
                    .tag("bolt")
            }
        }
    }
}

struct EnergeticButtonStyle: ButtonStyle {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    let isHovering: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                ZStack {
                    if isHovering {
                        BoltGrid()
                            .transition(.blurReplace)
                    }
                }
                .cornerRadius(10)
            }
            .background(Color.blue.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white.opacity(0.1), lineWidth: 0.5)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .foregroundStyle(isDarkMode ? Color.white : Color.white.opacity(0.9))
    }
}

#Preview {
    ContentView(controller: CaffeinateController())
}
