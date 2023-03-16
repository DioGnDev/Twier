//
//  CreateInteractor.swift
//  Twier
//
//

import Foundation
import Combine

protocol CreateInteractor {
  func createPost(username: String, text: String, image: Data?) -> AnyPublisher<Bool, DatabaseError>
}
