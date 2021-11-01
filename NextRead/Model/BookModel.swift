//
//  BookModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation

struct BookModel: Codable {
    let data: [BookDataModel]?

    enum CodingKeys: String, CodingKey {
        case data = "items"
    }
}

struct BookDataModel: Codable {
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    let title, description, publishedDate: String?
    let authors: [String]?
    let imageLinks: ImageLinks?
    let pageCount: Int?
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}
