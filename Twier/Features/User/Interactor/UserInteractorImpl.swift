//
//  UserInteractorImpl.swift
//  Twier
//
//

import Foundation
import Combine

class UserInteractorImpl: UserInteractor {
  
  private let repository: UserRepository
  var users: [User] = []
  var subscriptions = Set<AnyCancellable>()
  
  init(repository: UserRepository) {
    self.repository = repository
  }
  
  func createUser(name: String, username: String) -> AnyPublisher<Bool, DatabaseError> {
    fatalError()
  }
  
  func readUser() -> AnyPublisher<[User], DatabaseError> {
    return repository.getUsers().eraseToAnyPublisher()
      
  }
  
  func readUser(_ username: String) -> AnyPublisher<User, DatabaseError> {
    return repository.getUser(with: username).eraseToAnyPublisher()
  }
  
}
