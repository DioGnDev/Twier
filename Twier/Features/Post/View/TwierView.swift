//
//  TwierView.swift
//  Twier
//
//

import SwiftUI
import CoreData

struct TwierView: View {
  
  //Core Data
  //  @Environment(\.managedObjectContext) private var viewContext
  //  @FetchRequest(sortDescriptors: [],
  //                predicate: NSPredicate(format: "username == %@", UserSession.shared.username ?? ""),
  //                animation: .default)
  //  private var user: FetchedResults<User>
  //
  //  @FetchRequest(sortDescriptors: [])
  //  private var allPosts: FetchedResults<Post>
  //
  //  private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
  //  @State private var refreshing: Bool = false
  
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
                HStack {
                  Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                  
                  Text(presenter.name)
                }
                .foregroundColor(Color.black)
              }
              
              Spacer()
              
              presenter.linkBuilder {
                Label("", systemImage: "plus")
              }
            }
            .padding(.horizontal, 16)
          }
          .frame(height: 65)
          
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
