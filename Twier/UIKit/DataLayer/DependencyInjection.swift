//
//  DependencyInjection.swift
//  Twier
//
//

import Foundation

struct DependencyInjection {
  
  static var shared: DependencyInjection = DependencyInjection()
  
  public func provideCreateLocalData() -> CreateLocalDataSource{
    let context = PersistenceController.shared.container.viewContext
    return CreateLocalDataSourceImpl(context: context)
  }

  public func provideInteractor() -> CreateInteractor {
    return FakeCreateInteractorImpl(datasource: provideCreateLocalData())
  }
  
  public func provideTwierRouter() -> TwierRouter {
    return TwierRouter()
  }
  
}
