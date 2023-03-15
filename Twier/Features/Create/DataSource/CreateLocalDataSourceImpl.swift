//
//  CreateLocalDataSourceImpl.swift
//  Twier
//
//

import Foundation
import CoreData
import Combine

protocol CreateLocalDataSource {
  func createPost(text: String,
                  image: Data?,
                  context: NSManagedObjectContext) -> AnyPublisher<Bool, DatabaseError>
}


struct CreateLocalDataSourceImpl: CreateLocalDataSource{
  
  func createPost(text: String,
                  image: Data?,
                  context: NSManagedObjectContext) -> AnyPublisher<Bool, DatabaseError> {
    return Future<Bool, DatabaseError> { completion in
      completion(.failure(DatabaseError()))
    }.eraseToAnyPublisher()
  }
  
  
}
