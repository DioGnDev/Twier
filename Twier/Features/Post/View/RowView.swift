//
//  RowView.swift
//  Twier
//
//

import SwiftUI

struct RowView: View {
  
  let text: String
  let imageData: Data?
  
  var body: some View {
    HStack(alignment: .top, spacing: 10, content: {
      
      Image(systemName: "person.circle")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 30, height: 30)
        .clipShape(Circle())
      
      VStack(alignment: .leading) {
        
        Text(text)
          .frame(maxHeight: 100, alignment: .top)
        
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
  }
}


struct RowView_Previews: PreviewProvider {
  static var previews: some View {
    RowView(text: "", imageData: Data())
  }
}
