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
  var maxTabs: CGFloat = 2
  @State var tabOffset: CGFloat = 0
  
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
                  
                  Text(presenter.name)
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
              .padding(.horizontal, currentSelection == 0 ? 10 : -10)
            
            TabView(selection: $currentSelection) {
              MyPostView(items: $presenter.posts)
                .tag(0)
                .onAppear{ presenter.readPosts() }
              
              AllPostView(items: $presenter.allPosts)
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
