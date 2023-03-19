//
//  TwierPresenterTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import CoreData

final class TwierPresenterTests: XCTestCase {
  
  var sut: PostInteractor!
  var subscriptions = Set<AnyCancellable>()
  
  func test_readPosts_byUsername_andReturnSuccess() {
    //given
    let expectation = expectation(description: "Promise...")
    let context = PersistenceController.shared.container.viewContext
    let datasource = UserLocalDataSourceImpl(context: context)
    let repository = TwierUserRepository(localDatasource: datasource)
    let postLocalDatasource = PostLocalDatasourceImpl(context: context)
    
    var isSuccess: Bool = false
    var isError: Bool = false
    var posts: [Post] = []
    
    sut = TwierInteractorImpl(userRepository: repository,
                              postDatasource: postLocalDatasource)
    
    //when
    sut.readPosts()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          isError = true
        case .finished:
          break
        }
        expectation.fulfill()
      } receiveValue: { items in
        posts = items
        isSuccess = true
      }.store(in: &subscriptions)
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertTrue(isSuccess)
    XCTAssertFalse(isError)
    XCTAssertTrue(posts.count > 0)
    
  }
  
}
