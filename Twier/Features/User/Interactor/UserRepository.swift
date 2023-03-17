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
}


struct TwierUserRepository: UserRepository {
  
  func getUser(with username: String) -> AnyPublisher<User, DatabaseError> {
    return Future<User, DatabaseError> { completion in
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
  func getUsers() -> AnyPublisher<[User], DatabaseError> {
    return Future<[User], DatabaseError> { completion in
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
}
