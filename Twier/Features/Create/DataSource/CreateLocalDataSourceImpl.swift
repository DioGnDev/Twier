//
//  CreateLocalDataSourceImpl.swift
//  Twier
//
//

import Foundation
import CoreData
import Combine

protocol CreateLocalDataSource {
  func createPost(username: String,
                  text: String,
                  image: Data?,
                  context: NSManagedObjectContext) -> AnyPublisher<Bool, DatabaseError>
}


struct CreateLocalDataSourceImpl: CreateLocalDataSource{
  
  func createPost(username: String,
                  text: String,
                  image: Data?,
                  context: NSManagedObjectContext) -> AnyPublisher<Bool, DatabaseError> {
    return Future<Bool, DatabaseError> { completion in
      
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
