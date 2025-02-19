//
//  SensiWeaveApp.swift
//  SensiWeave
//
//  Created by user on 19/02/25.
//

import SwiftUI

@main
struct SensiWeaveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
