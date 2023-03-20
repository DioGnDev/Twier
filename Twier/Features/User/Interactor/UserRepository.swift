//
//  UserRepository.swift
//  Twier
//
//

import Foundation
import Combine

protocol UserRepository {
  func getUser(with username: String) -> AnyPublisher<User, DatabaseError>
  func getUsers() -> AnyPublisher<[User], DatabaseError>
  func createUser(name: String, username: String, avatar: String) -> AnyPublisher<Bool, DatabaseError>
}


struct TwierUserRepository: UserRepository {
  
  private let localDatasource: UserLocalDataSource
  
  init(localDatasource: UserLocalDataSource) {
    self.localDatasource = localDatasource
  }
  
  func createUser(name: String, username: String, avatar: String) -> AnyPublisher<Bool, DatabaseError> {
    return localDatasource.createUser(name: name, username: username, avatar: avatar)
  }
  
  func getUser(with username: String) -> AnyPublisher<User, DatabaseError> {
    return localDatasource.readUser(by: username)
  }
  
  func getUsers() -> AnyPublisher<[User], DatabaseError> {
    return localDatasource.readUser()
  }
  
}
