//
//  pockeAppApp.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//

import SwiftUI

@main
struct pockeAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
