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

protocol TwierInteractor {
  func checkUser()
  func createUsers()
  func readUsers() -> AnyPublisher<[User], DatabaseError>
}

class TwierInteractorImpl: TwierInteractor, PostInteractor {
  
  let userRepository: UserRepository
  
  var subscriptions = Set<AnyCancellable>()
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func checkUser(){
    userRepository.getUsers()
      .map{$0.isEmpty}
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          print("Error")
        case .finished:
          break
        }
        
      } receiveValue: { isEmpty in
        if isEmpty {
          self.createUsers()
        }
      }
      .store(in: &subscriptions)
  }
  
  func createUsers(){
    let user1 = UserModel(name: "Ilham", username: "ilham99")
    let user2 = UserModel(name: "Dio", username: "dio99")
    let user3 = UserModel(name: "JP", username: "jp6")
    
    let users = [user1, user2, user3]
    
    for user in users {
      userRepository.createUser(name: user.name, username: user.username)
        .receive(on: DispatchQueue.global(qos: .userInteractive))
        .sink { completion in
          print(completion)
        } receiveValue: { succeedded in
          print(succeedded)
        }.store(in: &subscriptions)
      
    }
  }
  
  func readPosts() -> AnyPublisher<[Post], DatabaseError> {
    fatalError()
  }
  
  func readUsers() -> AnyPublisher<[User], DatabaseError> {
    return userRepository.getUsers()
  }
  
}
