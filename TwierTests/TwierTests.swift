//
//  TwierTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import CoreData
import Combine

struct MockCreateLocalDataSourceImpl: CreateLocalDataSource {
  
  func createPost(text: String,
                  image: Data?,
                  context: NSManagedObjectContext) -> AnyPublisher<Bool, DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      
      let post = Post()
      post.postText = text
      post.image = image
      
      let user = User()
      user.user = "Dio"
      user.username = "diiyo"
      user.posts = NSSet(array: [post])
      
      do {
        try context.save()
        completion(.success(true))
      }catch {
        completion(.failure(.init()))
      }
      
    }.eraseToAnyPublisher()
    
  }
}

final class TwierTests: XCTestCase {
  
  var sut: CreateLocalDataSource!
  var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    
    sut = MockCreateLocalDataSourceImpl()
    
  }
  
  func test_saveToLocalDataAndReturnFailed() {
    //given
    var success: Bool = false
    var nerror: Bool = false
    let context = PersistenceController.shared.container.viewContext
    let expectation = expectation(description: "Promise...")
    let text = "Okay Apple ... i need your help!!!"
    
    
    //when
    sut.createPost(text: text,
                   image: Data(),
                   context: context)
    .receive(on: DispatchQueue.global(qos: .userInteractive))
    .sink { completion in
      switch completion {
      case .failure:
        nerror = true
      case .finished:
        break
      }
      expectation.fulfill()
    } receiveValue: { succeedded in
      success = succeedded
    }
    .store(in: &subscriptions)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertEqual(success, false)
    XCTAssertEqual(nerror, true)
  }
  
  func test_saveToLocalDataAndReturnSuccess() {
    //given
    var success: Bool = false
    var nerror: Bool = false
    let context = PersistenceController.shared.container.viewContext
    let expectation = expectation(description: "Promise...")
    let text = "Okay Apple ... i need your help!!!"
    
    
    //when
    sut.createPost(text: text,
                   image: Data(),
                   context: context)
    .receive(on: DispatchQueue.global(qos: .userInteractive))
    .sink { completion in
      switch completion {
      case .failure:
        nerror = true
      case .finished:
        break
      }
      expectation.fulfill()
    } receiveValue: { succeedded in
      success = succeedded
    }
    .store(in: &subscriptions)
    
    
    //then
    waitForExpectations(timeout: 5)
    XCTAssertEqual(success, true)
    XCTAssertEqual(nerror, false)
  }
  
}
