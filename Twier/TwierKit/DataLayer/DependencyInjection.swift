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
    return CreateInteractorImpl(dataSource: provideCreateLocalData())
  }
  
  public func provideTwierRouter() -> TwierRouter {
    return TwierRouter()
  }
  
  public func provideUserRepository() -> UserRepository{
    return TwierUserRepository(localDatasource: provideUserLocalDatasource())
  }
  
  public func providePostLocalDatasource() -> PostLocalDatasource {
    let context = PersistenceController.shared.container.viewContext
    return PostLocalDatasourceImpl(context: context)
  }
  
  public func provideTwierInteractor() -> TwierInteractor & PostInteractor {
    return TwierInteractorImpl(userRepository: provideUserRepository(),
                               postDatasource: providePostLocalDatasource())
  }
  
  public func provideUserSession() -> UserSession {
    return UserSession()
  }
  
  public func provideUserInteractor() -> UserInteractor {
    return UserInteractorImpl(repository: provideUserRepository())
  }
  
}
