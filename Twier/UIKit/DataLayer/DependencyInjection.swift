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

  public func provideUserLocalDatasource() -> UserLocalDataSource {
    let context = PersistenceController.shared.container.viewContext
    return UserLocalDataSourceImpl(context: context)
  }
  
  public func provideInteractor() -> CreateInteractor {
    return FakeCreateInteractorImpl(datasource: provideCreateLocalData())
  }
  
  public func provideTwierRouter() -> TwierRouter {
    return TwierRouter()
  }
  
  public func provideUserRepository() -> UserRepository{
    return TwierUserRepository(localDatasource: provideUserLocalDatasource())
  }
  
  public func provideTwierInteractor() -> TwierInteractor {
    return TwierInteractorImpl(userRepository: provideUserRepository())
  }
  
  public func provideUserSession() -> UserSession {
    return UserSession()
  }
  
  public func provideUserInteractor() -> UserInteractor {
    return UserInteractorImpl(repository: provideUserRepository())
  }
  
}
