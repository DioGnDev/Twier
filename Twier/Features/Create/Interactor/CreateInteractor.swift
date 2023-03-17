//
//  CreateInteractor.swift
//  Twier
//
//

import Foundation
import Combine

protocol CreateInteractor {
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, DatabaseError>
}

struct CreateInteractorImpl: CreateInteractor {
  
  let dataSource: CreateLocalDataSource
  
  init(dataSource: CreateLocalDataSource) {
    self.dataSource = dataSource
  }
  
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, Twier.DatabaseError> {
    
    return dataSource.createPost(username: username,
                                 text: text,
                                 image: image)
    
  }
  
  
}

struct FakeCreateInteractorImpl: CreateInteractor {
 
  let datasource: CreateLocalDataSource
  
  init(datasource: CreateLocalDataSource) {
    self.datasource = datasource
  }
  
  func createPost(username: String?,
                  text: String,
                  image: Data?) -> AnyPublisher<Bool, DatabaseError> {
    return Future<Bool, DatabaseError> { completion in
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
}
