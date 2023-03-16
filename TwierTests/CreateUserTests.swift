//
//  CreateUserTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import CoreData

final class CreateUserTests: XCTestCase {
  
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
    sut.createUser(name: "Diiyo", username: "diiyo99")
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
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
}
