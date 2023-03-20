//
//  User+CoreDataProperties.swift
//  Twier
//
//
//

import Foundation
import CoreData


extension User {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var username: String?
  @NSManaged public var avatar: String?
  @NSManaged public var posts: NSSet?
  
}

// MARK: Generated accessors for posts
extension User {
  
  @objc(addPostsObject:)
  @NSManaged public func addToPosts(_ value: Post)
  
  @objc(removePostsObject:)
  @NSManaged public func removeFromPosts(_ value: Post)
  
  @objc(addPosts:)
  @NSManaged public func addToPosts(_ values: NSSet)
  
  @objc(removePosts:)
  @NSManaged public func removeFromPosts(_ values: NSSet)
  
}

extension User : Identifiable {
  
}
