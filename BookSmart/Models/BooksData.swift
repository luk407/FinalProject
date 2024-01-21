//
//  Book.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import Foundation

struct BooksData: Decodable {
    let docs: [Book]
}

// MARK: - Doc
struct Book: Decodable, Hashable {
    let title: String
    let authorName: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
    }
}
