//
//  AllPostView.swift
//  Twier
//

import SwiftUI

struct AllPostView: View {
  @Binding var items: [Post]
  
  var body: some View {
    List(items) { post in
      RowView(text: post.message ?? "",
              imageData: post.image)
      .padding(.top, 16)
    }
    .listStyle(.plain)
  }
}

struct AllPostView_Previews: PreviewProvider {
  static var previews: some View {
    AllPostView(items: .constant([]))
  }
}
