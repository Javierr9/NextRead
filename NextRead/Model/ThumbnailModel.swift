//
//  BookThumbnailModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 01/10/21.
//

import Foundation
// The idea of thumbnail model is why do you need to load data you don't need when the one only used are the one that is here. 
struct ThumbnailDataModel{
    let id: String?
    let title: String?
    let authors: [String]?
    let smallThumbnail: String?
}
