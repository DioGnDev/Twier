//
//  TwierRouter.swift
//  Twier
//
//

import Foundation
import SwiftUI

struct TwierRouter {
  
  func makeCreateView() -> some View {
    
    let presenter = CreatePresenter(interactor: DependencyInjection.shared.provideInteractor(),
                                    userSession: UserSession(),
                                    router: CreateRouter())
    return CreateView(presenter: presenter)
  }
  
}
