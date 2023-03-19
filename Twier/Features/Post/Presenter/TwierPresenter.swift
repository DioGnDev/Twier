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
  }
  
  var name: String {
    return selectedUser.name
  }
  
  var username: String {
    return selectedUser.username
  }
  
  func checkUser() {
    interactor.checkUser()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
      } receiveValue: { [weak self] succeedded in
        guard let self = self else { return }
        self.selectedUser = UserModel(
          name: "",
          username: self.userSession.username ?? ""
        )
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
      .receive(on: DispatchQueue.main)
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
      .receive(on: DispatchQueue.main)
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
