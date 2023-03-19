//
//  CreatePresenter.swift
//  Twier
//
//

import Foundation
import SwiftUI
import Combine

class CreatePresenter: ObservableObject {
  
  //Dependencies
  private let interactor: CreateInteractor
  private let userSession: UserSession
  private let router: CreateRouter
  
  //Publisher
  @Published var isLoading: Bool = false
  @Published var errorMessage: String = ""
  @Published var text: String = ""
  @Published var image: UIImage? = nil
  @Published var isSuccess: Bool = false
  @Published var isActive: Bool = false
  @Published var presentError: Bool = false
  
  var subscriptions = Set<AnyCancellable>()
  
  init(interactor: CreateInteractor,
       userSession: UserSession,
       router: CreateRouter) {
    
    self.interactor = interactor
    self.userSession = userSession
    self.router = router
    
    bindToView()
    
  }
  
  func create(completion: @escaping () -> Void) {
    
    DispatchQueue.main.async {
      self.isLoading = true
    }
    
    interactor.createPost(username: userSession.username,
                          text: text,
                          image: image?.pngData())
    .receive(on: DispatchQueue.main)
    .sink { [weak self] completion in
      switch completion {
      case .failure(let error):
        self?.presentError.toggle()
        self?.errorMessage = error.message
        break
      case .finished:
        break
      }
      
      self?.isLoading = false
      
    } receiveValue: { [weak self] succeedded in
      self?.isSuccess = succeedded
      completion()
    }.store(in: &subscriptions)
    
    
  }
  
  private var isFormValid: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($text, $image)
      .map { txt, img in
        return !txt.isEmpty && img != nil
      }
      .eraseToAnyPublisher()
  }
  
  private func bindToView(){
    isFormValid
      .receive(on: DispatchQueue.main)
      .assign(to: &$isActive)
  }
  
}
