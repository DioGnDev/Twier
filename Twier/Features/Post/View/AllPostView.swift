//
//  AllPostView.swift
//  Twier
//

import SwiftUI

struct AllPostView: View {
  @Binding var items: [Post]
  var presenter: TwierPresenter
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        HStack {
          Spacer()
          presenter.seeAllLinkBuilder {
            Text("See All")
              .font(.headline)
              .fontWeight(.medium)
              .foregroundColor(Color.gray)
          }
        }
        .padding(.trailing, 15)
      }
      
      LazyVStack(alignment: .leading) {
        ForEach(items) { post in
          presenter.detailLinkBuilder {
            RowView(name: post.user?.name ?? "",
                    username: post.user?.username ?? "",
                    avatar: post.user?.avatar ?? "",
                    text: post.message ?? "",
                    imageData: post.image)
            .padding(.top, 16)
          }
        }
      }
    }
  }
}

struct AllPostView_Previews: PreviewProvider {
  static var previews: some View {
    AllPostView(items: .constant([]),
                presenter: TwierPresenter(interactor: DependencyInjection.shared.provideTwierInteractor(), userInteractor: DependencyInjection.shared.provideUserInteractor(), router: TwierRouter(), userSession: UserSession()))
  }
}
