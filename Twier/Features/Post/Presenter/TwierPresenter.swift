//
//  TwierPresenter.swift
//  Twier
//
//

import SwiftUI
import Combine

class TwierPresenter: ObservableObject {
  
  private let interactor: TwierInteractor & PostInteractor
  private let userInteractor: UserInteractor
  private let router: TwierRouter
  private var userSession: UserSession
  
  @Published var selectedUser: UserModel = .init(name: "", username: "")
  @Published var users: [User] = []
  @Published var posts: [Post] = []
  @Published var allPosts: [Post] = []
  @Published var errorMessage: String = ""
  
  //Cancellable
  var subscriptions = Set<AnyCancellable>()
  
  init(interactor: TwierInteractor & PostInteractor,
       userInteractor: UserInteractor,
       router: TwierRouter,
       userSession: UserSession) {
    
    self.interactor = interactor
    self.userInteractor = userInteractor
    self.router = router
    self.userSession = userSession
    
    self.getUserBy()
  }
  
  var name: String {
    return selectedUser.name
  }
  
  var username: String {
    return selectedUser.username
  }
  
  func getUserBy() {
    userInteractor.readUser(userSession.username ?? "")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
      } receiveValue: { [weak self] user in
        self?.selectedUser = UserModel(name: user.name ?? "",
                                       username: user.username ?? "")
      }.store(in: &subscriptions)
  }
  
  func checkUser() {
    interactor.checkUser()
  }
  
  func getUser() {
    
    userSession.username
      .publisher
      .map{ return !$0.isEmpty }
      .flatMap{ [weak self] _ -> AnyPublisher<[User], DatabaseError> in
        guard let strongSelf = self
        else {
          return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        return strongSelf.interactor.readUsers()
      }
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print(error.localizedDescription)
        case .finished:
          print("finished")
        }
      } receiveValue: { [weak self] users in
        self?.userSession.username = users[0].username
      }.store(in: &subscriptions)
    
  }
  
  func readUsers() {
    userInteractor.readUser()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure:
          break
        case .finished:
          break
        }
      } receiveValue: { [weak self] users in
        self?.users = users
      }.store(in: &subscriptions)
    
  }
  
  func readAllPost() {
    interactor.readPosts()
      .receive(on: DispatchQueue.global(qos: .userInteractive))
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.errorMessage = error.localizedDescription
          break
        case .finished:
          break
        }
      } receiveValue: { [weak self] items in
        self?.allPosts = items
      }.store(in: &subscriptions)
  }
  
  func readPosts() {
    userSession.username.publisher
      .compactMap { $0 }
      .flatMap { [weak self] username -> AnyPublisher<[Post], DatabaseError> in
        guard let strongSelf = self else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
        return strongSelf.interactor.readPosts(by: username)
      }
      .receive(on: DispatchQueue.global(qos: .userInteractive))
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          self?.errorMessage = error.localizedDescription
          break
        case .finished:
          break
        }
      } receiveValue: { [weak self] items in
        self?.posts = items
      }.store(in: &subscriptions)
    
    
  }
  
  func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    NavigationLink(
      destination: router.makeCreateView(),
      label: {
        content()
      })
  }
  
}
