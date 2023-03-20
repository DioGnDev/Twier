//
//  DatabaseError.swift
//  Twier
//
//

import Foundation

struct DatabaseError: Error {
  let id: Int
  let message: String
  
  init(){
    id = 0
    message = ""
  }
  
  init(id: Int, message: String) {
    self.id = id
    self.message = message
  }
  
}
