
import Foundation


extension URL {

    func appendQueries(_ queries: [String : Any]?) -> URL? {
        guard let queries = queries else {
            return self
        }

        var components = URLComponents(string: self.absoluteString)
        var queryItems: [URLQueryItem] = components?.queryItems ?? []
        queries.forEach {
            let queryItem = URLQueryItem(name: $0.key, value: "\($0.value)")
            if queryItems.contains(queryItem) == false {
                queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
        }
        components?.queryItems = queryItems
        return components?.url
    }
}
