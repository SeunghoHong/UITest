
import Foundation

import Alamofire
import RxSwift


class RESTClient {

    struct Response<T: Codable>: Codable {
        var status_code: String
        var detail: String
        var next: String
        var previous: String
        var results: [T]
    }

    static func json<T: Codable>(
        type: T.Type,
        url: String,
        method: Alamofire.HTTPMethod,
        queries: [String : Any]? = nil,
        body: String? = nil,
        headers: [String : String]? = [:]
    ) -> Observable<Result<Response<T>, Error>> {
        return Observable<Result<Response<T>, Error>>.create { observer -> Disposable in
            guard let url = URL(string: url),
                  let fullURL = url.appendQueries(queries)
            else {
                observer.onNext(.failure(NSError.trace()))
                return Disposables.create()
            }

            var customHeaders: [String : String] = [
                "User-Agent" : "Test/6.1.0(1334) CFNetwork/1220.1 Darwin/20.2.0 x86_64 iOS/14.4",
                "Accept" : "application/json",
                "Accept-Language" : "en-US"
            ]

            headers?.forEach { customHeaders[$0.0] = $0.1 }

            var parameters: [String : Any]?
            if let body = body?.data(using: .utf8) {
                do {
                    parameters = try JSONSerialization.jsonObject(with: body, options: .mutableContainers) as? [String : Any]
                } catch let e {
                    observer.onNext(.failure(e))
                }
            }

            let request = AF.request(
                    fullURL,
                    method: method,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: HTTPHeaders(customHeaders)
                )
                .validate()
                .responseDecodable(of: Response<T>.self) { response in
                    switch response.result {
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    case .success(let obj):
                        observer.onNext(.success(obj))
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
