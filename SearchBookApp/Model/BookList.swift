
import Foundation

struct BookList: Decodable {
    let books: [Book]

    enum RootCodingKeys: CodingKey {
        case documents
    }

    enum AuthorKeys: CodingKey {
        case authors
    }

    enum DocumentCodingKeys: CodingKey {
        case title
        case authors
        case contents
        case price
        case thumbnail
    }
}

extension BookList {
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)

        var documentsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .documents)

        var books: [Book] = []
        while !documentsContainer.isAtEnd {
            let documentContainer = try documentsContainer.nestedContainer(keyedBy: DocumentCodingKeys.self)

            let title = try documentContainer.decode(String.self, forKey: .title)

            var authorsContainer = try documentContainer.nestedUnkeyedContainer(forKey: .authors)

            var authors: [String] = []
            while !authorsContainer.isAtEnd {
                let author = try authorsContainer.decode(String.self)
                authors.append(author)
            }

            let contents = try documentContainer.decode(String.self, forKey: .contents)
            let price = try documentContainer.decode(Int.self, forKey: .price)
            let thumbnail = try documentContainer.decode(String.self, forKey: .thumbnail)

            books.append(Book(title: title, authors: authors, contents: contents, price: price, thumbnail: thumbnail))
        }
        self.books = books
    }
}

