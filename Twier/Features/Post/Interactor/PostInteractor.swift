//
//  PostInteractor.swift
//  Twier
//
//

import Foundation
import Combine

protocol PostInteractor {
  func readPosts() -> AnyPublisher<[Post], DatabaseError>
}

struct PostInteractorImpl: PostInteractor {
  
  let repository: PostRepository
  
  init(repository: PostRepository) {
    self.repository = repository
  }
  
  func readPosts() -> AnyPublisher<[Post], DatabaseError> {
    return Future<[Post], DatabaseError> { completion in
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
}
