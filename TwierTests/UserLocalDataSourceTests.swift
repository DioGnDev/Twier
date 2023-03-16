//
//  CreateUserTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import CoreData

final class UserLocalDataSourceTests: XCTestCase {
  
  var sut: UserLocalDataSource!
  var subscriptions = Set<AnyCancellable>()
  
  func test_createUserAndReturnSuccess() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceImpl(context: context)
    let expectation = expectation(description: "Promise...")
    
    var isSuccess: Bool = false
    var isError: Bool = false
    
    //when
    sut.createUser(name: "Ilham", username: "ilham99")
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
  
  func test_readDataFromCoreData() {
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
    XCTAssertEqual(posts!.count, 2)
    
  }
  
}

protocol UserLocalDataSource {
  func createUser(name: String, username: String) -> AnyPublisher<Bool, DatabaseError>
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
  
}
