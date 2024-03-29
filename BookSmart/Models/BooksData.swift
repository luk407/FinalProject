
import Foundation

struct BooksData: Decodable {
    let docs: [Book]
}

struct Book: Decodable, Hashable {
    let title: String
    let authorName: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
    }
}
