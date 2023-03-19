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
        .environment(\.colorScheme, .dark)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(
          TwierPresenter(
            interactor: DependencyInjection.shared.provideTwierInteractor(),
            userInteractor: DependencyInjection.shared.provideUserInteractor(),
            router: DependencyInjection.shared.provideTwierRouter(),
            userSession: DependencyInjection.shared.provideUserSession()
          )
        )
        .onAppear{
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "")
        }
    }
  }
}
