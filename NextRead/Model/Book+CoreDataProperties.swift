//
//  Book+CoreDataProperties.swift
//  NextRead
//
//  Created by Javier Fransiscus on 06/10/21.
//
//

import CoreData
import Foundation

public extension Book {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged var authors: [String]?
    @NSManaged var id: String?
    @NSManaged var isFavorite: Bool
    @NSManaged var isRecent: Bool
    @NSManaged var smallThumbnail: String?
    @NSManaged var title: String?
    @NSManaged var thumbnail: String?
}

extension Book: Identifiable {}
