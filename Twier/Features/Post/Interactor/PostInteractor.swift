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
  
  func readPosts() -> AnyPublisher<[Post], DatabaseError> {
    return Future<[Post], DatabaseError> { completion in
      completion(.failure(.init()))
    }.eraseToAnyPublisher()
  }
  
}
