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
    XCTAssertEqual(posts!.count, 2)
    
  }
  
  func test_readAllUserDataFromCoreData() {
    //given
    let context = PersistenceController.shared.container.viewContext
    sut = MockUserLocalDataSourceImpl(context: context)
    
    //when
    let fetchRequest = User.fetchRequest()
    let user = try? context.fetch(fetchRequest)
    
    //then
    XCTAssertEqual(user?.count, 2)
    
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
    fatalError()
  }
  
  func readUser(by username: String) -> AnyPublisher<Twier.User, Twier.DatabaseError> {
    fatalError()
  }
  
}
