//
//  TwierView.swift
//  Twier
//
//

import SwiftUI
import CoreData

struct TwierView: View {
  
  //View Properties
  @EnvironmentObject var presenter: TwierPresenter
  @State var showBottomSheet: Bool = false
  @State var currentSelection: Int = 0
  @State var posts: [Post] = []
  
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
                HStack(spacing: 10){
                  Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.red.opacity(0.3), radius: 5)
                  
                  Text(presenter.name)
                    .foregroundColor(Color.white)
                }
                .foregroundColor(Color.black)
              }
              
              Spacer()
              
              presenter.linkBuilder {
                Label("", systemImage: "plus")
                  .foregroundColor(Color.white)
              }
            }
            .padding(.horizontal, 16)
          }
          .frame(height: 65)
          
          HStack {
            
          }
          
          TabView {
            MyPostView(items: $presenter.posts)
              .onAppear{ presenter.readPosts() }
            
            AllPostView(items: $presenter.allPosts)
              .onAppear{ presenter.readAllPost() }
            
          }.tabViewStyle(.page(indexDisplayMode: .never))
          
        }
        
        BottomSheet(
          users: presenter.users,
          showSheet: $showBottomSheet,
          selectedUser: $presenter.selectedUser
        )
        .onAppear{
          presenter.readUsers()
        }
      }
      .onAppear{
        presenter.checkUser()
        showBottomSheet = false
      }
      .onChange(of: presenter.selectedUser) { newValue in
        presenter.readPosts()
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
          userInteractor: DependencyInjection.shared.provideUserInteractor(),
          router: DependencyInjection.shared.provideTwierRouter(),
          userSession: DependencyInjection.shared.provideUserSession()
        )
      )
  }
}
