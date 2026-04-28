//
//  ContentView.swift
//  Caffeinate
//
//  Created by Jack Rogers on 4/27/26.
//

import SwiftUI

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
            
            HStack {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                
                Button {
                    withAnimation { controller.toggleCaffeination() }
                } label: {
                    Label(
                        controller.isCaffeinated ? "Stop" : "Start",
                        systemImage: controller.isCaffeinated ? "pause.fill" : "play.fill"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
            }
        }
        .padding(12)
        .frame(width: 230)
    }
}

#Preview {
    ContentView(controller: CaffeinateController())
}
