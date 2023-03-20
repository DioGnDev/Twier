//
//  PostInteractor.swift
//  Twier
//
//

import Foundation
import Combine

protocol PostInteractor {
  func readPosts() -> AnyPublisher<[Post], DatabaseError>
  func readPosts(by username: String) -> AnyPublisher<[Post], DatabaseError>
}

protocol TwierInteractor {
  func checkUser() -> AnyPublisher<Bool, DatabaseError>
  func createUsers() -> AnyPublisher<Bool, DatabaseError>
  func getUser() -> AnyPublisher<Bool, DatabaseError>
}

class TwierInteractorImpl: TwierInteractor {
  
  let userRepository: UserRepository
  let postDatasource: PostLocalDatasource
  
  var subscriptions = Set<AnyCancellable>()
  
  init(userRepository: UserRepository,
       postDatasource: PostLocalDatasource) {
    
    self.userRepository = userRepository
    self.postDatasource = postDatasource
  }
  
  func checkUser() -> AnyPublisher<Bool, DatabaseError> {
    userRepository.getUsers()
      .map{ $0.isEmpty }
      .flatMap {
        return  $0 ? self.createUsers() : self.getUser()
      }
      .eraseToAnyPublisher()
  }
  
  func createUsers() -> AnyPublisher<Bool, DatabaseError>{
    
    return Future<Bool, DatabaseError> { completion in
      
      let user1 = UserModel(name: "Steve Vai", username: "steve", avatar: "steve_vai")
      let user2 = UserModel(name: "Joe Satriani", username: "joe", avatar: "joe_satriani")
      let user3 = UserModel(name: "John Petrucci", username: "jp6", avatar: "john_petrucci")
      
      let users = [user1, user2, user3]
      
      let group = DispatchGroup()
      let queue = DispatchQueue(label: "create_user")
      
      for user in users {
        group.enter()
        queue.async(group: group){ [weak self] in
          guard let self = self else { return }
          self.userRepository.createUser(name: user.name,
                                         username: user.username,
                                         avatar: user.avatar)
            .sink(receiveCompletion: { completion in
              print(completion)
            }, receiveValue: { succeedded in
              group.leave()
            }).store(in: &self.subscriptions)
        }
        
      }
      
      group.notify(queue: queue){
        UserSession.shared.username = user1.username
        completion(.success(true))
      }
      
    }.eraseToAnyPublisher()
    
  }
  
  func getUser() -> AnyPublisher<Bool, DatabaseError> {
    userRepository.getUsers()
      .map { users in
        return users.count > 0
      }
      .eraseToAnyPublisher()
  }
  
}

extension TwierInteractorImpl: PostInteractor {
  
  func readPosts() -> AnyPublisher<[Post], DatabaseError> {
    return postDatasource.readPosts().eraseToAnyPublisher()
  }
  
  func readPosts(by username: String) -> AnyPublisher<[Post], DatabaseError> {
    return postDatasource.readPosts(by: username).eraseToAnyPublisher()
  }
  
}
