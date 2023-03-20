//
//  CreatePresenterTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine

final class CreatePresenterTests: XCTestCase {
  
  var sut: CreateInteractor!
  var subscriptions = Set<AnyCancellable>()
  
  func test_createPostWithReturnFailed() {
    //given
    let expectation = expectation(description: "Promise...")
    let context = PersistenceController.shared.container.viewContext
    let dataSource = MockCreateLocalDataSourceFailed()
    
    var isSuccess: Bool = false
    var isError: Bool = false
    
    sut = CreateInteractorImpl(dataSource: dataSource)
    
    //when
    sut.createPost(username: "dio99",
                   text: "Test Post",
                   image: Data())
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
    XCTAssertTrue(isError)
    XCTAssertFalse(isSuccess)
  }
  
  func test_createPostWithFailure() {
    //given
    let expectation = expectation(description: "Promise...")
    let context = PersistenceController.shared.container.viewContext
    let dataSource = MockCreateLocalDataSourceImpl(context: context)
    
    var isSuccess: Bool = false
    var isError: Bool = false
    
    sut = MockCreateInteractorImpl(dataSource: dataSource)
    
    //when
    sut.createPost(username: "diiyo99",
                   text: "Test Post",
                   image: Data())
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
    XCTAssertFalse(isSuccess)
    XCTAssertTrue(isError)
    
  }
  
}

struct MockCreateInteractorImpl: CreateInteractor {
  
  let dataSource: CreateLocalDataSource
  
  init(dataSource: CreateLocalDataSource) {
    self.dataSource = dataSource
  }
  
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, Twier.DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      completion(.failure(.init(id: 100, message: "Database Error")))
    }.eraseToAnyPublisher()
    
  }
  
  
}
