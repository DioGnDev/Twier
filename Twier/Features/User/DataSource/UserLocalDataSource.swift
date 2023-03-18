//
//  UserLocalDataSource.swift
//  Twier
//
//

import Foundation
import Combine
import CoreData

protocol UserLocalDataSource {
  func createUser(name: String, username: String) -> AnyPublisher<Bool, DatabaseError>
  func readUser() -> AnyPublisher<[User], DatabaseError>
  func readUser(by username: String) -> AnyPublisher<User, DatabaseError>
  func deleteUser() -> AnyPublisher<Bool, DatabaseError>
}

struct UserLocalDataSourceImpl: UserLocalDataSource {
  
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func createUser(name: String, username: String) -> AnyPublisher<Bool, DatabaseError> {
    return Future<Bool, DatabaseError> { completion in
      let user = User(context: context)
      user.name = name
      user.username = username
      
      do {
        try context.save()
        completion(.success(true))
      }catch {
        completion(.failure(.init()))
      }
      
    }.eraseToAnyPublisher()
  }
  
  func readUser(by username: String) -> AnyPublisher<User, DatabaseError> {
    return Future<User, DatabaseError> { completion in
      let fetchRequest = User.fetchRequest()
      let predicate = NSPredicate(format: "username == %@", username)
      fetchRequest.predicate = predicate
      do {
        let users = try context.fetch(fetchRequest)
        guard let user = users.first else {
          completion(.failure(.init()))
          return
        }
        completion(.success(user))
      }
      catch {
        completion(.failure(.init()))
      }
    }.eraseToAnyPublisher()
  }
  
  func readUser() -> AnyPublisher<[User], DatabaseError> {
    return Future<[User], DatabaseError> { completion in
      let fetchRequest = User.fetchRequest()
      do {
        let users = try context.fetch(fetchRequest)
        completion(.success(users))
      }
      catch {
        completion(.failure(.init()))
      }
    }.eraseToAnyPublisher()
  }
  
  func deleteUser() -> AnyPublisher<Bool, DatabaseError> {
    fatalError()
  }
  
}
