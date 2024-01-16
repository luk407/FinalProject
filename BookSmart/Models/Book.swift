//
//  Book.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

struct BookData: Decodable {
    let docs: [Doc]
}

// MARK: - Doc
struct Doc: Decodable {
    let title: String
    let authorName: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
    }
}
