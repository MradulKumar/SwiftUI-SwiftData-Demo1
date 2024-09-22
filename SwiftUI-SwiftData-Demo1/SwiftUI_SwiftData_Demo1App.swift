//
//  SwiftUI_SwiftData_Demo1App.swift
//  SwiftUI-SwiftData-Demo1
//
//  Created by Mradul Kumar on 22/09/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftUI_SwiftData_Demo1App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
