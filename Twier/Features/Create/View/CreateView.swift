//
//  CreateView.swift
//  Twier
//
//

import SwiftUI

struct CreateView: View {
  
  @ObservedObject var presenter: CreatePresenter
  @State var isPresented: Bool = false
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      Section {
        Text("Write a post")
          .font(.subheadline)
          .foregroundColor(Color.gray)
        TextEditor(text: $presenter.text)
      }
      
      Section {
        VStack(alignment: .leading, spacing: 16) {
          Button {
            isPresented.toggle()
          } label: {
            Image(uiImage: presenter.image ?? UIImage(named: "placeholder")!)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity, maxHeight: 200)
              .background(Color.gray.opacity(0.2))
              .cornerRadius(8)
              .clipped(antialiased: true)
          }
          
          Text("Choose your image to upload")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(Color.gray)
          
        }
      }
      
      Section {
        Button {
          presenter.create { dismiss() }
        } label: {
          Text("Submit")
        }
        .frame(maxWidth: .infinity)
        .disabled(!presenter.isActive)
        
      }
      
    }
    .sheet(isPresented: $isPresented) {
      PhotoPicker(pickerResult: $presenter.image,
                  isPresented: $isPresented)
    }
    .alert(isPresented: $presenter.presentError) {
      Alert(
        title: Text("Error"),
        message: Text(presenter.errorMessage),
        dismissButton: .destructive(Text("Ok"))
      )
    }
    
  }
}

struct CreateView_Previews: PreviewProvider {
  static var previews: some View {
    let context = PersistenceController.shared.container.viewContext
    CreateView(
      presenter: CreatePresenter(
        interactor: CreateInteractorImpl(
          dataSource: CreateLocalDataSourceImpl(context: context)
        ),
        userSession: UserSession(),
        router: CreateRouter()
      )
    )
  }
}
