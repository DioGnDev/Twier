//
//  UserInteractorTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import CoreData

final class UserInteractorTests: XCTestCase {
  
  var sut: UserLocalDataSource!
  var subscriptions = Set<AnyCancellable>()
  
  func test_runAllTheTests(){
    test_createUserAndReturnSuccess()
    test_readAllUserDataFromCoreData()
    test_deleteUserFromCoreData()
    test_readUsersAndReturnEmpty()
  }
  
  func test_createUserAndReturnSuccess() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceImpl(context: context)
    let expectation = expectation(description: "Promise...")
    
    var isSuccess: Bool = false
    var isError: Bool = false
    
    //when
    sut.createUser(name: "Dio", username: "dio99")
      .receive(on: DispatchQueue.global(qos: .userInteractive))
      .sink { completion in
        switch completion {
        case .failure:
          isError = true
        case .finished:
          break
        }
        expectation.fulfill()
      } receiveValue: { succeedded in
        isSuccess = succeedded
      }.store(in: &subscriptions)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertTrue(isSuccess)
    XCTAssertFalse(isError)
  }
  
  func test_readUserFromCoreDataAndReturnSpesificUser() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceImpl(context: context)
    
    //when
    let fetchRequest = User.fetchRequest()
    let predicate = NSPredicate(format: "username == %@", "ilham99")
    fetchRequest.predicate = predicate
    let user = try? context.fetch(fetchRequest)
    let posts = user?.first.map{$0.posts.map{$0.allObjects}} ?? []
    
    //then
    XCTAssertNotNil(posts)
    
  }
  
  func test_readAllUserDataFromCoreData() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceImpl(context: context)
    
    //when
    let fetchRequest = User.fetchRequest()
    let user = try? context.fetch(fetchRequest)
    
    //then
    XCTAssertNotNil(user)
    
  }
  
  func test_deleteUserFromCoreData() {
    //given
    let context = PersistenceController.shared.container.viewContext
    let expectation = expectation(description: "Promise...")
    sut = MockUserLocalDataSourceImpl(context: context)
    
    var isError: Bool = false
    var isSuccess: Bool = false
    
    //when
    sut.deleteUser()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print(error.localizedDescription)
          isError = true
        case .finished:
          break
        }
        expectation.fulfill()
      } receiveValue: { succeedded in
        isSuccess = succeedded
      }.store(in: &subscriptions)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertFalse(isError)
    XCTAssertTrue(isSuccess)
    
    
  }
  
  func test_readUsersAndReturnEmpty() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceEmpty(context: context)
    let expectation = expectation(description: "Promise...")
    
    var empty: Bool = false
    var isError: Bool = false
    
    //when
    sut.readUser()
      .map{$0.isEmpty}
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          isError = true
        case .finished:
          break
        }
        expectation.fulfill()
      } receiveValue: { isEmpty in
        empty = isEmpty
      }
      .store(in: &subscriptions)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertTrue(empty)
    XCTAssertFalse(isError)
    
  }
  
}

struct MockUserLocalDataSourceImpl: UserLocalDataSource {
  
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
  
  func readUser() -> AnyPublisher<[Twier.User], Twier.DatabaseError> {
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
  
  func readUser(by username: String) -> AnyPublisher<Twier.User, Twier.DatabaseError> {
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
  
  func deleteUser() -> AnyPublisher<Bool, DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      
      var isError: Bool = false
      
      let fetchRequest = User.fetchRequest()
      guard let users = try? context.fetch(fetchRequest)
      else {
        completion(.failure(.init()))
        return
      }
      
      for user in users {
        context.delete(user)
        do {
          try context.save()
        }catch{
          print(error.localizedDescription)
          isError = true
        }
      }
      
      if isError {
        completion(.failure(.init()))
      }
      
      completion(.success(true))
      
    }.eraseToAnyPublisher()
  }
}

struct MockUserLocalDataSourceEmpty: UserLocalDataSource {
  
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
  
  func readUser() -> AnyPublisher<[Twier.User], Twier.DatabaseError> {
    return Future<[User], DatabaseError> { completion in
      completion(.success([]))
    }.eraseToAnyPublisher()
  }
  
  func readUser(by username: String) -> AnyPublisher<Twier.User, Twier.DatabaseError> {
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
  
  func deleteUser() -> AnyPublisher<Bool, DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      
      var isError: Bool = false
      
      let fetchRequest = User.fetchRequest()
      guard let users = try? context.fetch(fetchRequest)
      else {
        completion(.failure(.init()))
        return
      }
      
      for user in users {
        context.delete(user)
        do {
          try context.save()
        }catch{
          print(error.localizedDescription)
          isError = true
        }
      }
      
      if isError {
        completion(.failure(.init()))
      }
      
      completion(.success(true))
      
    }.eraseToAnyPublisher()
  }
}
