//
//  MyPostView.swift
//  Twier
//
//

import SwiftUI

struct MyPostView: View {
  
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

struct MyPostView_Previews: PreviewProvider {
  static var previews: some View {
    MyPostView(items: .constant([]))
  }
}

