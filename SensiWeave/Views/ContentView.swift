//
//  ContentView.swift
//  SensiWeave
//
//  Created by user on 19/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuestionnaireView()
                .tabItem {
                    Label("Questionnaire", systemImage: "list.bullet")
                }

            FabricLibraryView()
                .tabItem {
                    Label("Fabric Library", systemImage: "book")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
