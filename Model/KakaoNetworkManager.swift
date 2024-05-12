
import Foundation

final class KakaoNetworkManager {
    func getBookInfo(by name: String) async -> [Book]? {
        // URLComponents를 사용하여 URL 구성
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dapi.kakao.com"
        urlComponents.path = "/v3/search/book"
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: name)
        ]

        print(urlComponents.url!)

        // URLRequest 인스턴스 생성
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET" // 요청에 사용할 HTTP 메서드 설정

        // HTTP 헤더 설정
        request.setValue("KakaoAK 624f6f4ad5f7f29ddc4ec56b4a6a4f3d", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            //디코딩까지 묶어서 작업한 뒤 리턴
            let (data, _) = try await URLSession.shared.data(for: request)
            let bookList = try JSONDecoder().decode(BookList.self, from: data)

            dump(bookList)
            return bookList.books
        }
        catch {
            debugPrint("Error loading : \(String(describing: error))")
            return nil
        }
    }
}
