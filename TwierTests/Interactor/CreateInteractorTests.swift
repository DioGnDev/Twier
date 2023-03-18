//
//  CreateInteractorTests.swift
//  TwierTests
//
//

import XCTest
@testable import Twier
import Combine
import CoreData

final class CreateInteractorTests: XCTestCase {
  
  var sut: CreateLocalDataSource!
  var subscriptions = Set<AnyCancellable>()
  
  func test_saveToLocalDataAndReturnFailed() {
    //given
    sut = MockCreateLocalDataSourceFailed()
    
    let expectation = expectation(description: "Promise...")
    let text = "Okay Apple ... i need your help!!!"
    
    var success: Bool = false
    var nerror: Bool = false
    
    //when
    sut.createPost(username: "diiyo99",
                   text: text,
                   image: Data())
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
    let context = PersistenceController.shared.container.viewContext
    let expectation = expectation(description: "Promise...")
    let text = "Okay Amazon ... i need your help!!! I'm still less than a year into investing, but haven't been able to find a mentor.. suggestions?"
    
    var success: Bool = false
    var nerror: Bool = false
    
    sut = MockCreateLocalDataSourceImpl(context: context)
    
    //when
    sut.createPost(username: "ilham99",
                   text: text,
                   image: Data())
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

struct MockCreateLocalDataSourceFailed: CreateLocalDataSource {
  
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      
      completion(.failure(.init()))
      
    }.eraseToAnyPublisher()
    
  }
}

struct MockCreateLocalDataSourceImpl: CreateLocalDataSource {
  
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, DatabaseError> {
    
    return Future<Bool, DatabaseError> { completion in
      
      guard let username = username else {
        completion(.failure(.init()))
        return
      }
      
      let userFetchRequest = User.fetchRequest()
      let predicate = NSPredicate(format: "username == %@", username)
      userFetchRequest.predicate = predicate
      guard let user = try? context.fetch(userFetchRequest).first else {
        return completion(.failure(.init()))
      }
      
      //create post
      let post = Post(context: context)
      post.message = text
      post.image = image
      post.user = user
      
      do {
        try context.save()
        completion(.success(true))
      }catch {
        completion(.failure(.init()))
      }
      
    }.eraseToAnyPublisher()
    
  }
}
