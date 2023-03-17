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
      TwierView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(TwierPresenter(router: DependencyInjection.shared.provideTwierRouter()))
        .onAppear{
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "")
        }
    }
  }
}
