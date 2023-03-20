//
//  EmptyPostView.swift
//  Twier
//
//

import SwiftUI

struct EmptyPostView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image("empty_file")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
      
      Text("You don't have any data")
        .font(.title3)
        .fontWeight(.medium)
        .foregroundColor(Color.black.opacity(0.5))
      
      Spacer()
    }
  }
}

struct EmptyPostView_Previews: PreviewProvider {
  static var previews: some View {
    EmptyPostView()
  }
}
