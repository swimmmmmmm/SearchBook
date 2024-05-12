import Foundation

struct Book: Equatable {
    let title: String
    let authors: [String]
    let contents: String
    let price: Int
    let thumbnail: String
}

extension Book {
    static var added = [Book]()
    static var recentlryRead = [Book]()
}
