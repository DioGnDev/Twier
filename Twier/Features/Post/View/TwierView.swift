//
//  TwierView.swift
//  Twier
//
//

import SwiftUI

struct TwierView: View {
  
  @EnvironmentObject var presenter: TwierPresenter
  
  var body: some View {
    NavigationView {
      Text("Hello")
        .toolbar {
          ToolbarItem {
            presenter.linkBuilder {
              Label("Add Item", systemImage: "plus")
            }
          }
        }
    }
    
  }
}

struct TwierView_Previews: PreviewProvider {
  static var previews: some View {
    TwierView()
      .environmentObject(TwierPresenter(router: DependencyInjection.shared.provideTwierRouter()))
  }
}
