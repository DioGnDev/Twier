//
//  RowView.swift
//  Twier
//
//

import SwiftUI

struct RowView: View {
  
  let name: String
  let username: String
  let avatar: String
  let text: String
  let imageData: Data?
  
  var body: some View {
    HStack(alignment: .top, spacing: 10, content: {
      
      Image(avatar)
        .resizable()
        .frame(width: 30, height: 30)
        .foregroundColor(Color("PrimaryColor"))
        .clipShape(Circle())
        .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 4)
      
      VStack(alignment: .leading, spacing: 8) {
        
        (
          Text(name)
            .font(.headline)
            .foregroundColor(Color.black)
          +
          Text(" @\(username)")
            .font(.headline)
            .foregroundColor(Color.gray)
        )
        .padding(.bottom, 8)
        
        Text(text)
          .font(.subheadline)
          .fontWeight(.medium)
          .frame(maxHeight: 100, alignment: .top)
          .foregroundColor(Color.black.opacity(0.7))
          .multilineTextAlignment(.leading)
        
        if let postImage = imageData,
           let uiimage = UIImage(data: postImage){
          
          GeometryReader{proxy in
            
            Image(uiImage: uiimage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: proxy.frame(in: .global).width, height: 250)
              .cornerRadius(15)
          }
          .frame(height: 250)
        }
      }
    })
    .padding(.horizontal, 10)
  }
}


struct RowView_Previews: PreviewProvider {
  static var previews: some View {
    RowView(name: "Diiyo",
            username: "diiyo99",
            avatar: "steve_vai",
            text: "",
            imageData: Data())
  }
}
