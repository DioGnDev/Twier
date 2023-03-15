//
//  Post+CoredataProperties.swift
//  Twier
//
//

import Foundation
import CoreData

extension Post {
  @NSManaged var postText: String
  @NSManaged var image: Data?  
}
