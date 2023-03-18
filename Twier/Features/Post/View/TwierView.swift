//
//  TwierView.swift
//  Twier
//
//

import SwiftUI

struct TwierView: View {
  
  @EnvironmentObject var presenter: TwierPresenter
  @State var showBottomSheet: Bool = false
  
  var body: some View {
    NavigationView {
      
      ZStack {
        
        VStack {
          
          VStack {
            HStack {
              Button {
                withAnimation {
                  showBottomSheet.toggle()
                }
              } label: {
                HStack {
                  Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                  Text(presenter.userName)
                }
              }
              
              Spacer()
              
              presenter.linkBuilder {
                Label("", systemImage: "plus")
              }
            }
            .padding(.horizontal, 16)
          }
          .frame(height: 65)
          
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
              ForEach(0..<20) { i in
                Text("Row \(i+1)")
                  .padding(.horizontal, 16)
              }
            }
            
          }
        }
        .onAppear{
          presenter.getUser()
          showBottomSheet = false
        }
        
        BottomSheet(
          users: presenter.users,
          showSheet: $showBottomSheet,
          selectedUser: $presenter.selectedUser
        )
        
      }
    }
    
  }
  
}

struct TwierView_Previews: PreviewProvider {
  static var previews: some View {
    TwierView()
      .environmentObject(
        TwierPresenter(
          interactor: DependencyInjection.shared.provideTwierInteractor(),
          router: DependencyInjection.shared.provideTwierRouter(),
          userSession: DependencyInjection.shared.provideUserSession()
        )
      )
  }
}
