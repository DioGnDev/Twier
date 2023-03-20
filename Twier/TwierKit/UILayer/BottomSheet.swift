//
//  BottomSheet.swift
//  Twier
//

import SwiftUI
import Combine

struct BottomSheet: View {
  
  private var userSession: UserSession
  @ObservedObject var presenter: TwierPresenter
  @State var offset: CGFloat = 0
  @Binding var showSheet: Bool
  @Binding var selectedUser: UserModel
  
  let users: [User]
  var subscriptions = Set<AnyCancellable>()
  
  init(userSession: UserSession,
       presenter: TwierPresenter,
       users: [User],
       showSheet: Binding<Bool>,
       selectedUser: Binding<UserModel>) {
    
    self.userSession = userSession
    self.presenter = presenter
    self.users = users
    self._showSheet = showSheet
    self._selectedUser = selectedUser
  }
  
  var body: some View {
    
    VStack{
      
      Spacer()
      
      VStack(spacing: 16){
        
        Capsule()
          .fill(Color.gray)
          .frame(width: 60, height: 4)
        
        Text("Switch User")
          .font(.headline)
        
        ScrollView(.vertical, showsIndicators: false) {
          
          VStack(alignment: .leading, spacing: 8) {
            
            ForEach(users){ user in
              
              Button {
                selectedUser = UserModel(name: user.name ?? "",
                                         username: user.username ?? "",
                                         avatar: user.avatar ?? "")
                self.userSession.setUsername(user.username ?? "")
                withAnimation {
                  showSheet.toggle()
                }
              } label: {
                
                HStack(alignment: .bottom, spacing: 12) {
                  
                  Image(user.avatar ?? "")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("PrimaryColor"))
                    .clipShape(Circle())
                  
                  VStack(alignment: .leading) {
                    Text(user.name ?? "")
                      .font(.headline)
                      .foregroundColor(.black)
                    
                    Text("@\(user.username ?? "")")
                      .font(.subheadline)
                      .fontWeight(.medium)
                      .foregroundColor(Color.gray)
                  }
                  
                  
                  Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .padding(.horizontal, 24)
                .padding(.vertical, 5)
                
              }
            }
          }
          .padding(.horizontal)
          .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3.5)
        .contentShape(Rectangle())
      }
      .padding(.top)
      .background(BlurView(style: .systemMaterialLight)
        .clipShape(CustomCorner(corners: [.topLeft, .topRight]))
      )
      .offset(y: offset)
      // bottom sheet remove swipe gesture....
      .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
      .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
    }
    .ignoresSafeArea()
    .background(
      Color.black
        .opacity(showSheet ? 0.5 : 0)
        .ignoresSafeArea()
        .onTapGesture(perform: {
          withAnimation{ showSheet.toggle() }
        })
    )
    .onAppear{
      presenter.readUsers()
    }
  }
  
  func onChanged(value: DragGesture.Value){
    
    if value.translation.height > 0{
      
      offset = value.translation.height
    }
  }
  
  func onEnded(value: DragGesture.Value){
    
    if value.translation.height > 0{
      
      withAnimation(Animation.easeIn(duration: 0.2)){
        
        // checking.....
        
        let height = UIScreen.main.bounds.height / 3
        
        if value.translation.height > height / 1.5{
          showSheet.toggle()
        }
        offset = 0
      }
    }
  }
}

