//
//  User+CoreDataProperties.swift
//  Twier
//
//

import Foundation

extension User {
  @NSManaged var user: String
  @NSManaged var username: String
  @NSManaged var posts: NSSet?
}
