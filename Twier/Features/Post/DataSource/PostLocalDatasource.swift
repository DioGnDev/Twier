//
//  PostLocalDatasource.swift
//  Twier
//
//

import Foundation
import Combine
import CoreData

protocol PostLocalDatasource {
  func readPosts() -> AnyPublisher<[Post], DatabaseError>
  func readPosts(by username: String) -> AnyPublisher<[Post], DatabaseError>
}

struct PostLocalDatasourceImpl: PostLocalDatasource {
  
  let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  func readPosts() -> AnyPublisher<[Post], DatabaseError> {
    return Future<[Post], DatabaseError> { completion in
    
      let fetchPostRequest = Post.fetchRequest()
      
      do {
        let posts = try context.fetch(fetchPostRequest)
        completion(.success(posts))
      }catch {
        completion(.failure(.init()))
      }
      
    }.eraseToAnyPublisher()
  }
  
  func readPosts(by username: String) -> AnyPublisher<[Post], DatabaseError> {
    return Future<[Post], DatabaseError> { completion in
      
      let fetchUserRequest = User.fetchRequest()
      let fetchPostRequest = Post.fetchRequest()
      let predicate = NSPredicate(format: "username == %@", username)
      fetchUserRequest.predicate = predicate
      
      do {
        let user = try context.fetch(fetchUserRequest)
        let posts = try context.fetch(fetchPostRequest).filter{ $0.user == user.first }
        completion(.success(posts))
      }catch {
        completion(.failure(.init()))
      }
      
    }.eraseToAnyPublisher()
  }
  
}
