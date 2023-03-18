//
//  TwierPresenter.swift
//  Twier
//
//

import SwiftUI
import Combine

class TwierPresenter: ObservableObject {
  
  private let interactor: TwierInteractor
  private let userInteractor: UserInteractor
  private let router: TwierRouter
  private var userSession: UserSession
  
  @Published var selectedUser: UserModel
  @Published var users: [User] = []
  
  //Cancellable
  var subscriptions = Set<AnyCancellable>()
  
  init(interactor: TwierInteractor,
       userInteractor: UserInteractor,
       router: TwierRouter,
       userSession: UserSession) {
    
    self.interactor = interactor
    self.userInteractor = userInteractor
    self.router = router
    self.userSession = userSession
    
    selectedUser = .init(name: "mantab", username: "mantab9")
  }

  var name: String {
    return selectedUser.name
  }
  
  var username: String {
    return selectedUser.username
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
  
  func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    NavigationLink(
      destination: router.makeCreateView(),
      label: {
        content()
      })
  }
  
}
