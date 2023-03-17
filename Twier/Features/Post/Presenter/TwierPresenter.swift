//
//  TwierPresenter.swift
//  Twier
//
//

import Foundation
import SwiftUI

class TwierPresenter: ObservableObject {
  
  let router: TwierRouter
  
  init(router: TwierRouter) {
    self.router = router
  }
  
  func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    NavigationLink(
      destination: router.makeCreateView(),
      label: {
        content()
      })
  }
  
  
}
