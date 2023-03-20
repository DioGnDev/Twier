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
  @State var tabOffset: CGFloat = 0
  var maxTabs: CGFloat = 2
  
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
                HStack(spacing: 16){
                  Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.white)
                    .shadow(color: Color.red, radius: 5)
                  
                  Text(UserSession.shared.username ?? "")
                }
                .foregroundColor(Color.black)
              }
              
              Spacer()
              
              presenter.linkBuilder {
                Label("Add", systemImage: "plus")
                  .foregroundColor(Color("PrimaryColor"))
                  .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 5)
              }
            }
            .padding(.horizontal, 16)
          }
          .frame(height: 50)
          
          VStack {
            HStack {
              Text("My Posts")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  withAnimation {
                    currentSelection = 0
                    tabOffset = 0
                  }
                }
              Text("All Posts")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  withAnimation {
                    currentSelection = 1
                    tabOffset = getScreenBounds().width / maxTabs
                  }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 45)
            .padding(.horizontal, 20)
            
            // Indicator...
            Capsule()
              .fill(Color("PrimaryColor"))
              .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 5)
              .frame(maxWidth: .infinity, alignment: .leading)
              .offset(x: tabOffset)
            
            TabView(selection: $currentSelection) {
              MyPostView(items: $presenter.posts, presenter: presenter)
                .tag(0)
                .onAppear{ presenter.readPosts() }
              
              AllPostView(items: $presenter.allPosts,
                          presenter: presenter)
              .tag(1)
              .onAppear{ presenter.readAllPost() }
              
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: currentSelection) { newValue in
              withAnimation {
                tabOffset = newValue == 0 ? 0 : getScreenBounds().width / maxTabs
              }
            }
            
          }
          
        }
        
        BottomSheet(
          userSession: UserSession.shared,
          presenter: presenter,
          users: presenter.users,
          showSheet: $showBottomSheet,
          selectedUser: $presenter.selectedUser
       )
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
