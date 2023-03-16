//
//  UserInteractor.swift
//  Twier
//
//

import Foundation
import Combine

protocol UserInteractor {
  func createUser(name: String, username: String) -> AnyPublisher<Bool, DatabaseError>
  func readUser() -> AnyPublisher<[User], DatabaseError>
  func readUser(_ username: String) -> AnyPublisher<User, DatabaseError>
}
