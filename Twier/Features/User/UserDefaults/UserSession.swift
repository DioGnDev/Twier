//
//  UserSession.swift
//  Twier
//
//

import Foundation

struct UserSession {
  
  public static var shared = UserSession()
  
  public var username: String? {
    get {
      UserDefaults.standard.string(forKey: "USERNAME")
    }
    
    set {
      UserDefaults.standard.set(newValue, forKey: "USERNAME")
    }
  }

}
