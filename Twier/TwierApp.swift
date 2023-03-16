//
//  TwierApp.swift
//  Twier
//

import SwiftUI

@main
struct TwierApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .onAppear{
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "")
        }
    }
  }
}
