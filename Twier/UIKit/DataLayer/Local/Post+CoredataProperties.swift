//
//  Post+CoreDataProperties.swift
//  Twier
//
//
//

import Foundation
import CoreData

extension Post {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
    return NSFetchRequest<Post>(entityName: "Post")
  }
  
  @NSManaged public var image: Data?
  @NSManaged public var message: String?
  @NSManaged public var user: User?
  
}

extension Post : Identifiable {
  
}
