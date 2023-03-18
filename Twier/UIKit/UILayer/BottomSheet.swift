//
//  BottomSheet.swift
//  Twier
//

import SwiftUI
import Combine

struct BottomSheet: View {
  
  @State var offset: CGFloat = 0
  @Binding var showSheet: Bool
  @Binding var selectedUser: UserModel
  
  let users: [User]
  var subscriptions = Set<AnyCancellable>()
  
  init(users: [User],
       showSheet: Binding<Bool>,
       selectedUser: Binding<UserModel>) {
    
    self.users = users
    self._showSheet = showSheet
    self._selectedUser = selectedUser
  }
  
  var body: some View {
    
    VStack{
      
      Spacer()
      
      VStack(spacing: 12){
        
        Capsule()
          .fill(Color.gray)
          .frame(width: 60, height: 4)
        
        Text("Switch User")
          .foregroundColor(.gray)
        
        ScrollView(.vertical, showsIndicators: false) {
          
          VStack(spacing: 8){
            
            ForEach(users){ user in
              Button {
                selectedUser = UserModel(name: user.name ?? "",
                                         username: user.username ?? "")
                withAnimation {
                  showSheet.toggle()
                }
              } label: {
                HStack(alignment: .bottom) {
                  Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                  Text(user.name ?? "")
                }
                
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
      .background(BlurView().clipShape(CustomCorner(corners: [.topLeft,.topRight])))
      .offset(y: offset)
      // bottom sheet remove swipe gesture....
      .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
      .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
    }
    .ignoresSafeArea()
    .background(
      Color.black
        .opacity(showSheet ? 0.4 : 0)
        .ignoresSafeArea()
        .onTapGesture(perform: {
          withAnimation{ showSheet.toggle() }
        })
    )
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

